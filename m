From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 14:36:08 -0500
Message-ID: <4CC9D0A8.8030209@redhat.com>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com> <20101028175221.GA1578@arch.trippelsdorf.de> <20101028180118.GC6814@thunk.org> <20101028193211.GA28126@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sfr@canb.auug.org.au,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759471Ab0J1TgX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 15:36:23 -0400
In-Reply-To: <20101028193211.GA28126@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote:
> On Thu, Oct 28, 2010 at 02:01:18PM -0400, Ted Ts'o wrote:
>> On Thu, Oct 28, 2010 at 07:52:21PM +0200, Markus Trippelsdorf wrote:
>>> The same BUG (inode.c:2721) happend here today running latest vanilla
>>> git. There is nothing in my logs unfortunately, but I shot a photo of
>>> the trace (see attachment).
>> I see, it's the page_buffers() call which is triggering.  Looking into
>> it...
> 
> Can folks let me know if this fixes the problem?

Ted, any idea what caused the change in behavior here?

-Eric

> In this case I haven't been able to replicate the problem, but I've
> eyeballed the problem and I'm about 90% certain this should fix
> things.  But I don't want to push this to Linus until I get
> confirmation from you all that it fixes things.  That's just one of
> the ways in which your testing is critically important for ext4, so
> thanks again for your help in the past, present, and future.
> Thanks!!
> 
> 						- Ted
> 
> commit 51279fcb9720aa856ad81673886ca2349a373dac
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu Oct 28 15:15:21 2010 -0400
> 
>     ext4: BUG_ON fix: check if page has buffers before calling page_buffers()
>     
>     We need to make check if a page does not have buffes by checking
>     page_has_buffers(page) before calling page_buffers(page) in
>     ext4_writepage().  Otherwise page_buffers() could throw a BUG_ON.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2d6c6c8..1916164 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2718,7 +2718,7 @@ static int ext4_writepage(struct page *page,
>  	 * try to create them using __block_write_begin.  If this
>  	 * fails, redirty the page and move on.
>  	 */
> -	if (!page_buffers(page)) {
> +	if (!page_has_buffers(page)) {
>  		if (__block_write_begin(page, 0, len,
>  					noalloc_get_block_write)) {
>  		redirty_page:
> @@ -2732,12 +2732,10 @@ static int ext4_writepage(struct page *page,
>  	if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
>  			      ext4_bh_delay_or_unwritten)) {
>  		/*
> -		 * We don't want to do block allocation So redirty the
> -		 * page and return We may reach here when we do a
> -		 * journal commit via
> -		 * journal_submit_inode_data_buffers.  If we don't
> -		 * have mapping block we just ignore them. We can also
> -		 * reach here via shrink_page_list
> +		 * We don't want to do block allocation, so redirty
> +		 * the page and return.  We may reach here when we do
> +		 * a journal commit via journal_submit_inode_data_buffers.
> +		 * We can also reach here via shrink_page_list
>  		 */
>  		goto redirty_page;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

