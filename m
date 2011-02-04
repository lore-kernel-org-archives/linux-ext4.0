From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: e2fsprogs git master branch
Date: Fri, 4 Feb 2011 15:40:27 -0700
Message-ID: <831EA70A-C209-480B-B9C0-17B12995295A@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:7554 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1BDWk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Feb 2011 17:40:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,
I was going to port some of the Lustre patches to the master branch of e2fsprogs (where I thought 1.42 would be derived from, with the >16TB changes).  However, it looks like master is only up-to-date with v1.41.12 (as per version.h and the RELEASE-NOTES files), and not 1.41.14.

Is "master" the right place to be porting patches for 1.42, or is there some other target ("next", perhaps) that is the right place to go?

Perhaps a few words in README, or README.git that describes the branches would be useful?

Cheers, Andreas





