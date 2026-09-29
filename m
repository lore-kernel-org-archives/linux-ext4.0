Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DAA549390
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790704124; cv=none; b=YpfKGBII3hg3XD7u6Ze8vlV28WFCB4wNYOzinm5wrDJXRDPQMN9TPBAz/vrwMazBCRdsFhGxo5BmeeoEl7lSCIoNSXi0pyKqniuhb/N81sClsLFtGwetg1dtkCER5+jCmrwzKsAPWRkbB2xO53ivAPUNtdXQ8O3bAOGuMq33WLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790704124; c=relaxed/simple;
	bh=Yqkr516dodCMQRjpkAVVeP2deGGsz+nctIBugY5R4V4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=cFBvB/JmN4s8JnEtl57xWGtGG/m4/w8hpkft0GJ5c3g/6JG6zdnorru/Guac001MhDK7g/A0U1t3ZUnVisa3OIhlvKkoFq9lkVYsF/ZFBWIEJwOsP4/zo6av5BDrLVFYrwLF7NBOGfFXEIywkBCac9ZJO1vAiNI1qoYyuqYuiFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d5s8TMDr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d5s8TMDr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790704121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ETicKdBpGWuIenEMTtqcrWuHBlfUne40odEeT39lTdo=;
	b=d5s8TMDrjGJtrNoDWZRyfENGxeGYLD8Ltlv8R0xpgl1aQ7qPNegJQuBuOp3Nv6FkkrRBJU
	du+IDjnc0dx+kYd+ZZfnqVgkWfj/P6LN567rmOToDUyIfznoHKxGSf1KcCTC0XBqunGepO
	xQgfd6beLvDyk51xBXQ9Z/TgED4LKGU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-385-QlROogDBMTCYXt4kiSjtDg-1; Tue,
 29 Sep 2026 13:48:36 -0400
X-MC-Unique: QlROogDBMTCYXt4kiSjtDg-1
X-Mimecast-MFC-AGG-ID: QlROogDBMTCYXt4kiSjtDg_1790704114
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E89A1944DFE;
	Tue, 29 Sep 2026 17:48:34 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F21B476A;
	Tue, 29 Sep 2026 17:48:31 +0000 (UTC)
Date: Tue, 29 Sep 2026 19:48:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Baokun Li <libaokun1@huawei.com>, Jan Kara <jack@suse.cz>, 
    Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
    Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
    Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>
cc: linux-ext4@vger.kernel.org
Subject: regression - ext4 fails to mount a filesystem due to large orphan
 file
Message-ID: <e65cdbfe-3ff9-4638-fbd3-4d8f8880966f@redhat.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463801984-239856173-1790704114=:585089"
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463801984-239856173-1790704114=:585089
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

Hi

I report a bug in the commit 7c11c56eb32eae96893eebafdbe3decadefe88ad. 
The commit introduces a regression into the ext4 filesystem:

# truncate -s 1GiB ext4.test
# mkfs.ext4 -b 1024 ext4.test
mke2fs 1.47.4 (6-Mar-2025)
Discarding device blocks: done
Creating filesystem with 1048576 1k blocks and 65536 inodes
Filesystem UUID: 246857e4-85e8-4393-b3c7-d52a92b999e9
Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553,
        1024001

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

# mount -o loop ext4.test /mnt/test
mount: /mnt/test: volání fsconfig() selhalo: Struktura potøebuje opravu.
       dmesg(1) mù¾e obsahovat více údajù o selhaném pøipojení.
# dmesg |tail
[ 2325.547222] EXT4-fs (loop0): mounted filesystem 3af6fb51-f5c5-44af-84f1-d94e098f66d0 r/w with ordered data mode. Quota mode: none.
[ 2325.549968] EXT4-fs (loop0): unmounting filesystem 3af6fb51-f5c5-44af-84f1-d94e098f66d0.
[ 2325.585469] loop0: detected capacity change from 0 to 134217728
[ 2325.589344] EXT4-fs (loop0): mounted filesystem f6d86dae-c171-45ea-9e52-7d0de64d449c r/w with ordered data mode. Quota mode: none.
[ 2325.592672] EXT4-fs (loop0): unmounting filesystem f6d86dae-c171-45ea-9e52-7d0de64d449c.
[ 2374.988529] EXT4-fs (dm-0): unmounting filesystem 794eeb51-98fb-4d5c-b511-e4a56817ee6c.
[ 2376.433633] brd: module unloaded
[ 2906.044816] loop0: detected capacity change from 0 to 2097152
[ 2906.052278] EXT4-fs (loop0): orphan file too big: 1048576
[ 2906.052388] EXT4-fs (loop0): mount failed
# mkfs.ext4 -V
mke2fs 1.47.4 (6-Mar-2025)
        Using EXT2FS Library version 1.47.4

(the limit 512 blocks seems to be enforced in mke2fs in git, but 
distributions still use the last released version 1.47.4, which can 
produce filesystems with larger orphan list)

Mikulas
---1463801984-239856173-1790704114=:585089--

