# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111005211652) do

  create_table "guaranteereports", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "producer"
    t.string   "purchase_date"
    t.string   "purchase_place"
    t.string   "purchase_id"
    t.string   "purchase_guarantee_id"
    t.string   "rodzaj"
    t.string   "pin"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "comment"
  end

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.string   "producer"
    t.string   "product_name"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "order_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
  end

  create_table "postguaranteereports", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "email"
    t.string   "producer"
    t.string   "rodzaj"
    t.string   "description"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "comment"
  end

end
