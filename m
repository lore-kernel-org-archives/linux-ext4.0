From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/8] e2fsprogs: Add big_journal feature for Next3
Date: Mon, 21 Jun 2010 12:21:52 -0600
Message-ID: <3E370776-8EA9-445D-8366-4975AD1FA57C@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@users.sf.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:33793 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab0FUSVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jun 2010 14:21:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Next3 transactions reserve up to 24 times more credits than Ext3 transactions for the same operation.  On mke2fs and tune2fs, if the 'big_journal' feature is set along with the 'has_journal' feature, increase the default journal size by a factor of 24.

It is already possible to specify an arbitrary journal size with "-J size={MB}", so there is no need to consume a feature flag just to hint what the journal size should be.

It would be possible to check for some other snapshot-related feature flag, like "EXCLUDE_INODE" to determine if the journal is large enough for snapshotting, if it was deleted by e2fsck.  Otherwise, it is best to let the user specify the journal size they want.

Cheers, Andreas





