From: supersud501 <supersud501@yahoo.de>
Subject: e2fsck ext4 with extents possible?
Date: Wed, 30 Jan 2008 11:54:03 +0100
Message-ID: <47A0574B.1000002@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp010.mail.ukl.yahoo.com ([217.12.11.79]:27094 "HELO
	smtp010.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754262AbYA3RHi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 12:07:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hello,

i'm testing the ext4-filesystem for months now (no data loss experienced 
), but i noticed e2fsck not being able to check a ext4-filesystem with 
extents ("e2fsck: Filesystem has unsupported feature(s)").

i just pulled linus' kernel tree (with the newly added patches to ext4) 
and e2fsprogs git tree (from git.kernel.org), but still e2fsprogs is not 
able to check my ext4-fs.

so i wonder whether there's somewhere a patch for e2fsprogs flying 
around i've missed or whether checking ext4 with extents is simply not 
supported yet? if so, how's development going on with this?
