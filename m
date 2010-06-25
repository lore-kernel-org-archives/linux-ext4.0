From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: problems with large group descriptors and 64bit
Date: Thu, 24 Jun 2010 18:35:16 -0600
Message-ID: <BE781EC4-8A82-478F-8D10-BC19C0664567@oracle.com>
References: <C14E4BEF-0064-4E36-975F-B74272E246B1@oracle.com> <20100624174117.GD22760@shell>
Mime-Version: 1.0 (iPhone Mail 8A293)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.orgdevelopment" <linux-ext4@vger.kernel.org>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:62375 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0FYAgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2010 20:36:40 -0400
In-Reply-To: <20100624174117.GD22760@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2010-06-24, at 11:41 AM, Valerie Aurora <vaurora@redhat.com> wrote:

> On Tue, Jun 22, 2010 at 05:24:34PM -0600, Andreas Dilger wrote:
> 
>> lib/ext2fs/blknum.c assumes 64BIT means ext4_group_desc, not s_desc_size:
>> struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
>>                                          struct opaque_ext2_group_desc *gdp,
>>                                          dgrp_t group)
>> {               
>>        if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT)
>>                return (struct ext2_group_desc *)
>>                        ((struct ext4_group_desc *) gdp + group);
>>        else
>>                return (struct ext2_group_desc *) gdp + group;
>> }
> 
> I'm not sure I understand.  Are there more than two possible sizes for
> group descriptors?  Or is the existing code correct but you'd like to
> use s_desc_size directly for simplicity?

When the 64BIT flag is set the size kid the group descriptor is given by s_group_desc, which is currently the same as struct ext4_group_desc, but it might be larger in the future. 