From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: WARNING: at fs/ext4/extents.c:4434 ext4_convert_unwritten_extent
Date: Fri, 28 Sep 2012 21:23:30 +0400
Message-ID: <87ipay9i3x.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:43066 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab2I1RXd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2012 13:23:33 -0400
Received: by lagh6 with SMTP id h6so1186066lag.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2012 10:23:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've got this on 286'th MOUNT_OPTIONS=-onoload

We assumes that we are protected from ENOSPC during
ext4_convert_unwritten_extents() by passing EXT4_GET_BLOCKS_PRE_IO
on submitting AIO which split extent via ext4_split_unwritten_extents()
But this is not sufficient:


submit_aio                              Fallocate worker
 ->ext4_map_blocks(lblk, len)
   ->ext4_ext_map_blocks( )
   file: U1---------------------U2|_____EOF
     ->ext4_split_unwritten_extents
   file: U1------U1|U2---len----U2|_____EOF
              
                                       ->ext4_fallocate(lblk, len+len2)
                                          ->ext4_map_blocks()
                                             ->ext4_ext_map_blocks()
                                                         U2: Grows
                                           file: U1-------U1|U2----len+len2--U2|__EOF
  worker_tread
   ->ext4_end_io_work
     ->ext4_convert_unwritten_extents
       ->ext4_ext_handle_uninitialized_extents
            ## Discover that new split required in order to get:
            file: U1-------U1|U2----len----U2|U3--len2--U2__EOF
            This procedure fail with ENOSPC
       
