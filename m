From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Re: block allocation for ext2_mkdir
Date: Fri, 19 Dec 2008 01:22:39 +0530
Message-ID: <2d08ef090812181152r53fa9d18j1b21310c4e592f@mail.gmail.com>
References: <2d08ef090812181042k2b15f27fke39076cc72453797@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:27014 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYLRTwk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 14:52:40 -0500
Received: by wf-out-1314.google.com with SMTP id 27so623655wfd.4
        for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 11:52:39 -0800 (PST)
In-Reply-To: <2d08ef090812181042k2b15f27fke39076cc72453797@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 19, 2008 at 12:12 AM, Rohit Sharma <imreckless@gmail.com> wrote:
> How does ext2 allocate blocks for directory.
>
> ext2_mkdir               calls            ext2_make_empty
>
> ext2_make_empty     calls           __ext2_write_begin
>
> __ ext2_write_begin   calls           block_write_begin
>
> my query is that how does this function allocates blocks for directories. ??
>

Does ext2 uses ext2_get_block to allocate blocks for both files and
directories. ??
