From: Amir Goldstein <amir73il@gmail.com>
Subject: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Fri, 4 Feb 2011 00:33:39 +0200
Message-ID: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: lsf-pc@lists.linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62367 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1BCWdj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 17:33:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have been working on porting Next3 snapshots to Ext4
with a group of 4 CS students.

This is where it all happens:
https://github.com/amir73il/ext4-snapshots

Ext4 snapshots prototype is already working!
Would you like to see a demo?

I would like to present the progress of our work
and discuss the remaining issues and how they should be best addressed.

Additionally, I would like to discuss the need for a unified snapshots API that
would serve both Ext4 and Btrfs.
This could be useful for someone that wants to implement a generic
snapshots management system.

Amir.
