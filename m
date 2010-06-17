From: "Amir G." <amir73il@users.sourceforge.net>
Subject: [LSF TOPIC] [ATTEND] Next3 snapshots in Ext4
Date: Thu, 17 Jun 2010 10:32:39 +0300
Message-ID: <AANLkTink_0Whv8q286Gy0yFXJ6pvFPK0UN-93uTUM9u6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: lsf10-pc@lists.linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab0FQHcm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2010 03:32:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I got comments from many people, including Ric, that would like to see
Next3 snapshots merged into Ext4,
so I would like to attend and discuss some of the issues related to the merge.

Agenda from the top of my head:
1. Overview of the Next3 snapshots implementation in Ext3
2. How to deal with move-on-write of data blocks in extent mapped files?
3. How to guaranty snapshots data consistency on copy-on-write of
non-journaled data blocks?
4. What are the implications of delayed allocation on consistency of snapshots?
5. how to deal with file fragmentation due to move-on-write?

Thanks,
Amir.
