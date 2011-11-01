From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: let ext4_ext_convet_to_initialized initialize
 var(eh) before using it
Date: Tue, 1 Nov 2011 18:52:22 -0400
Message-ID: <20111101225222.GH32161@thunk.org>
References: <1320110481-12080-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Gouriou <egouriou@google.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44404 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab1KAWw0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 18:52:26 -0400
Content-Disposition: inline
In-Reply-To: <1320110481-12080-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 09:21:21AM +0800, Yongqiang Yang wrote:
> ext4_ext_convert_to_initialized() does not initialize eh before using it
> and this is introduced in commit 864d21652.
> 
> Cc:Eric Gouriou <egouriou@google.com>
> Cc:"Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

>  		eof_block = map->m_lblk + map->m_len;
>  
>  	depth = ext_depth(inode);
> +	eh = path[depth].p_hdr;
>  	ex = path[depth].p_ext;
>  	ee_block = le32_to_cpu(ex->ee_block);
>  	ee_len = ext4_ext_get_actual_len(ex);

Hmmm, nice catch.

Looks like Eric dropped this line when he forward ported this patch to
v3.1.  Interestingly, I did test this using xfstests, and it didn't
complain.  Which probably means we don't have a good test coverage
that triggers the specific preconditions of this optimization.  Oops.
I'll fix this up now.

Eric, when you have a chance, could you work up an xfstests test that
automates the various tests that you ran manually when you developed
this patch?  Thanks!!

						- Ted
