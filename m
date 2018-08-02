From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: mballoc: Fix spectre gadget in
 ext4_mb_regular_allocator
Date: Thu, 2 Aug 2018 00:06:09 -0400
Message-ID: <20180802040609.GD9187@thunk.org>
References: <20180730180747.25200-1-jcline@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org
To: Jeremy Cline <jcline@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180730180747.25200-1-jcline@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 30, 2018 at 06:07:47PM +0000, Jeremy Cline wrote:
> 'ac->ac_g_ex.fe_len' is a user-controlled value which is used in the
> derivation of 'ac->ac_2order'. 'ac->ac_2order', in turn, is used to
> index arrays which makes it a potential spectre gadget. Fix this by
> sanitizing the value assigned to 'ac->ac2_order'.  This covers the
> following accesses found with the help of smatch:
> 
> * fs/ext4/mballoc.c:1896 ext4_mb_simple_scan_group() warn: potential
>   spectre issue 'grp->bb_counters' [w] (local cap)
> 
> * fs/ext4/mballoc.c:445 mb_find_buddy() warn: potential spectre issue
>   'EXT4_SB(e4b->bd_sb)->s_mb_offsets' [r] (local cap)
> 
> * fs/ext4/mballoc.c:446 mb_find_buddy() warn: potential spectre issue
>   'EXT4_SB(e4b->bd_sb)->s_mb_maxs' [r] (local cap)
> 
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: stable@vger.kernel.org
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Jeremy Cline <jcline@redhat.com>

Thanks, applied.

					- Ted
