From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] make ext{3,4}_xattr_list() static
Date: Mon, 18 Feb 2008 05:01:52 -0800
Message-ID: <20080218050152.bb85314f.akpm@linux-foundation.org>
References: <20080217081823.GK3848@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761335AbYBRNDl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 08:03:41 -0500
In-Reply-To: <20080217081823.GK3848@cs181133002.pp.htv.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 17 Feb 2008 10:18:23 +0200 Adrian Bunk <bunk@kernel.org> wrote:

>  fs/ext3/xattr.c |    4 +++-
>  fs/ext3/xattr.h |    7 -------
>  fs/ext4/xattr.c |    4 +++-
>  fs/ext4/xattr.h |    7 -------

one patch per fs, please.
