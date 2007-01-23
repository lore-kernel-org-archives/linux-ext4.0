From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 0/3] i_version update for ext4
Date: Tue, 23 Jan 2007 18:23:54 +0100
Message-ID: <45B644AA.1070409@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49044 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965050AbXAWRYf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2007 12:24:35 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I've updated what was previously the change attribute patch for ext4 
initially posted by Alexandre Ratchov. The previous patch was 
introducing a change_attribute field, now it uses the i_version field of 
the inode.

The i_version field is a counter that is set on every inode creation and 
that is incremented every time the inode data is modified (similarly to 
the "ctime" time-stamp).
The aim is to fulfill NFSv4 requirements for rfc3530.
For the moent, the counter is only a 32bit value but it is planned to be 
64bit as required.

The patch is divided into 3 parts, the vfs layer, the ext4 specific code 
and an user part to check i_version changes via stat.


Any comments are welcome.

regards,
Jean noel
