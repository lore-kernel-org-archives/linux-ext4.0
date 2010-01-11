From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Mon, 11 Jan 2010 15:06:58 -0500
Message-ID: <4B4B84E2.1050508@redhat.com>
References: <4B46FCB2.1090308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Michal Novotny <minovotn@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab0AKUGj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2010 15:06:39 -0500
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0BK6dHE027717
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jan 2010 15:06:39 -0500
In-Reply-To: <4B46FCB2.1090308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/08/2010 04:36 AM, Michal Novotny wrote:
> This patch extends functionality of e{2|4}fsprogs to add 
> EXT2_FLAG_DIRECT flag to be passed to ext2fs_open2() function. This 
> internally calls open() function with O_DIRECT and handles the memory 
> alignment for both read and write operations.
> In some cases direct access to devices is necessary and that was the 
> main reason for this patch to be done.
>
> The main reason why this was done is that pygrub (used by xen 
> virtualization user-space package, it's a python version of grub for 
> paravirtualized guests) sometimes uses outdated version of grub.conf 
> file. Modifications to xen package were *not* enough because e2fsprogs 
> doesn't open the files directly. That's why I added EXT2_FLAG_DIRECT 
> support to make read/write operations work directly when passed. It's 
> been tested with pygrub like mentioned above for read operation and 
> it's working fine.
>
> Signed-off-by: Michal Novotny <minovotn@redhat.com>

Can you add to this some kind of data flow overview?  Seems like a 
really odd way to update this file system...

ric

