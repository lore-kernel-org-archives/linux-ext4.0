Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40763 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404407AbeKWBVo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2018 20:21:44 -0500
Received: by mail-wr1-f65.google.com with SMTP id p4so9504629wrt.7
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 06:42:04 -0800 (PST)
Date: Thu, 22 Nov 2018 14:42:00 +0000
From: Phillip Potter <phil@philpotter.co.uk>
To: Jan Kara <jack@suse.cz>
Cc: jack@suse.com, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v4 04/09] ext2: use common file type conversion
Message-ID: <20181122144200.GA26035@pathfinder>
References: <20181121190653.GA7710@pathfinder>
 <20181122114023.GE9840@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122114023.GE9840@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 22, 2018 at 12:40:23PM +0100, Jan Kara wrote:
> On Wed 21-11-18 19:06:53, Phillip Potter wrote:
> > Deduplicate the ext2 file type conversion implementation - file systems
> > that use the same file types as defined by POSIX do not need to define
> > their own versions and can use the common helper functions decared in
> > fs_types.h and implemented in fs_types.c
> > 
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza

Dear Jan,

Thank you for reviewing this patch, and for all the others too. Much
appreciated.

Regards,
Phil
