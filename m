From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: Query FSCK Errors on ext4
Date: Wed, 20 Nov 2013 13:35:21 +0100
Message-ID: <528CAC89.1040405@itwm.fraunhofer.de>
References: <008701cecc19$14734370$3d59ca50$@ntlworld.com> <F81EF3B4-CEBF-43FD-BD38-0AFFF56014C6@dilger.ca> <20131028063905.GA9017@gmail.com> <000e01ced3bc$2af03220$80d09660$@ntlworld.com> <13AE0AAC-F9F6-404F-B55E-F38C2015864B@dilger.ca> <001f01cee525$0be60e20$23b22a60$@ntlworld.com> <AB177EF8-199A-4A6D-A08F-2A6951F5F100@dilger.ca> <002901cee54d$b7d2efa0$2778cee0$@ntlworld.com> <93E08C0E-E398-4C7C-B7E7-C0591F6AA722@dilger.ca> <002a01cee568$c588cf00$509a6d00$@ntlworld.com> <C8263588-E5AD-4C23-81E3-5852DE3B1FC5@dilger.ca> <002e01cee56f$46f8e3d0$d4eaab70$@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "'Zheng Liu'" <gnehzuil.liu@gmail.com>,
	"'David Jeffery'" <djeffery@redhat.com>,
	linux-ext4@vger.kernel.org, "'Eric Whitney'" <enwlinux@gmail.com>
To: Stephen Elliott <techweb@ntlworld.com>,
	"'Andreas Dilger'" <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:50362 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3KTMf2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Nov 2013 07:35:28 -0500
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id rAKCZP0G007579
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 20 Nov 2013 13:35:25 +0100
In-Reply-To: <002e01cee56f$46f8e3d0$d4eaab70$@ntlworld.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Stephen,

can you reproduce this on a fresh filesystem and on a system that you 
can easily update? If you can, can you update the kernel to a 
stable/recent version (i.e. longterm 3.10) and e2fsprogs to a current 
version, re-create a fresh file system and try to reproduce again? If 
you still can, can you try to figure out which order of syscalls is 
causing the corruption? Or anything else that might help to figure out 
the root cause?
In general, using a rather old kernel and user space tools and pointing 
to an issue isn't going to help you much.


Cheers,
Bernd



