From: Theodore Ts'o <tytso@mit.edu>
Subject: Ext4 projects for 2014
Date: Sun, 8 Dec 2013 20:43:30 -0500
Message-ID: <20131209014330.GA9195@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37869 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760194Ab3LIBnh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Dec 2013 20:43:37 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Unfortunately, I forgot my notes from our last conference call before
heading off to the airport.  My fault for taking the notes on paper
instead of electronically in the first place.  :-(

This is my best reconstruction of some of the ext4 projects for 2014.
Please let me know if I've forgotten anything.

1)  Support for Shingled (SMR) Drives

2)  Data block compression -- Lukas

3)  reflink support --- Mingming
       block-level snapshot support
       Use case:  (a) VM guest images which are mostly derived from
       	   	      the same common master image

4)  Subvolume quotas (aka project quotas) -- Zheng

5)  block improvements -- raid support / flash block size

6)  Better support for non-rotating media
       Differences between thinp and flash?
       General problem: how do we measure improvements in the
       block allocator?

Other more minor todo items:

A)  Finish integration of inline support in e2fsprogs

B)  Dioread nolock cleanup

C)  Extent status tree shrinker


						- Ted

