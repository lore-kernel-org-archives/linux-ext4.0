From: mingming cao <mingming.cao@oracle.com>
Subject: [RFC 0/2] ext4 btree
Date: Mon, 22 Jun 2015 20:24:36 -0700
Message-ID: <1435029878-4517-1-git-send-email-mingming.cao@oracle.com>
Cc: mingming cao <mingming.cao@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34866 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbbFWGQB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2015 02:16:01 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t5N6G0xM003940
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 06:16:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t5N6G0Ja028391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 06:16:00 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t5N6G0IS025620
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 06:16:00 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello list,

Last week during ext4 weekly call, we discussed about some of design issues with ext4 btree.  Some background about ext4 btree -- when we started to look at ext4 reflink feature, one of the key design issue is how to store/index the refcount(number of times a range of disk blocks being shared) efficially on disk. Btree seems to a good data structure to serve that purpose.  So I started to look at a ext4 btree to store refcounts for sharing data blocks.  I started to play with a in memory btree (ideas from linux btree library) and have implemented basic functionality of btrees -- insert, delete, split, merge etc...

And while we a a btree for ext4,  there are raising interest to design a more flexible and generic ext4 btree, so we might able to use it for other purpose, like data checksumming, directories, etc other metadata.  We plan to use a ext4_btree_geo structure to define a btree layout and use many access functions to get into the btree index keys or leaf records. The key size and record size are defined by the geometry when initialize a btree. If there are other btree users like to have variable length records within a leaf node, that could be considered in the design too.

As where to root of btree store on disk for reflink, Darrick initially suggested to have a per-flexible block group refcount btree.. The plan is to create a new on-disk per-flexbg metadata structure, which will stores the root block of the reflink (and maybe to store other per-flex bg btrees in the future), and the block to store the new per-flexbg metadata structure will be stored in the last unused 32bit of the block group descriptor... This way we will have  the other options considered are 1) store the the root on the reflinked inode's extended attributes, so the btrees are per-reflink-related files only 2) or we have a globle per-filesystem reflink btree that sorts the refcount of physical blocks for entire filesystem, which maybe create lock contention whenever cow happens.

Attached is the very early draft of the btree prototype still looks very basic -- just to show the ideas about the btree in hope to find out who are  interested in using btrees in ext4 and what is missing .. I am very looking forward to ideas, suggestions, and comments..critics are welcomed too!


Mingming
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
