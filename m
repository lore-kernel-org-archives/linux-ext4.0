From: Valerie Clement <valerie.clement@bull.net>
Subject: e2fsck: unknown feature flag in journal superblock
Date: Thu, 29 May 2008 16:47:30 +0200
Message-ID: <483EC202.8070408@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53220 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbYE2Ors (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 May 2008 10:47:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I don't know if you are aware of this, when running e2fsck on an ext4 f=
ilesystem=20
which was mounted with "journal_async_commit" option, the following err=
or is=20
reported:

e2fsck 1.41-WIP (27-Apr-2008)
Ext3 journal superblock has an unknown incompatible feature flag set.
Abort<y>?

Seen with e2fsck from the latest next branch (1.41-WIP)

   Val=E9rie
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
