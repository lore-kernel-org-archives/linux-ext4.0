From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to
 specify if the caller can deal with ENOMEM
Date: Wed, 25 May 2011 00:47:06 -0700
Message-ID: <4DDCB3FA.2070009@gmail.com>
References: <4DDCAF18.8030809@gmail.com> <20110525074457.GA4427@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64523 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab1EYHrJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 03:47:09 -0400
Received: by pvg12 with SMTP id 12so3295211pvg.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 00:47:08 -0700 (PDT)
In-Reply-To: <20110525074457.GA4427@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/25/2011 12:44 AM, Jan Kara wrote:
> This patch is OK as such but as I wrote in a reply to a later patch in
> the series, you also need to pass 'errok' to start_this_handle() instead of
> gfp_mask as well. Then in start_this_handle() you can use 'errok' to decide
> whether we should retry the allocation or not instead of gfp_mask. And just
> call kzalloc in start_this_handle() with GFP_NOFS... Thanks.

Hi Jan,

   ok.. I will do it as a separate patch.

-- 
Thanks -
Manish
