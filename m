From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Don't check io->flag when setting EXT4_STATE_DIO_UNWRITTEN
 inode state.
Date: Wed, 26 Oct 2011 15:44:50 +0800
Message-ID: <4EA7BA72.508@tao.ma>
References: <1315984587-5039-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:37955 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754450Ab1JZHoy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 03:44:54 -0400
In-Reply-To: <1315984587-5039-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/14/2011 03:16 PM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we want to convert the unitialized extent in direct write,
> we can either do it in ext4_end_io_nolock(AIO case) or in
>  ext4_ext_direct_IO(non AIO case) and EXT4_I(inode)->cur_aio_dio
> is a guard for ext4_ext_map_blocks to find the right case.
> In e9e3bcecf, we mistakenly change it by:
> -			if (io)
> +			if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
>  				io->flag = EXT4_IO_END_UNWRITTEN;
> -			else
> +				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +			} else
>  				ext4_set_inode_state(inode,
>  						     EXT4_STATE_DIO_UNWRITTEN);
> 
> So now if we map 2 blocks, and the first one set the EXT_IO_END_UNWRITTEN, the
> 2nd mapping will set inode state because of the check for the flag. This is
> wrong.
> 
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
ping?
> ---
>  fs/ext4/extents.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 57cf568..8db6743 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3190,9 +3190,11 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
>  		 * that this IO needs to conversion to written when IO is
>  		 * completed
>  		 */
> -		if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
> -			io->flag = EXT4_IO_END_UNWRITTEN;
> -			atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +		if (io) {
> +			if (!(io->flag & EXT4_IO_END_UNWRITTEN)) {
> +				io->flag = EXT4_IO_END_UNWRITTEN;
> +				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +			}
>  		} else
>  			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
>  		if (ext4_should_dioread_nolock(inode))
> @@ -3572,9 +3574,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  		 * that we need to perform conversion when IO is done.
>  		 */
>  		if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
> -			if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
> -				io->flag = EXT4_IO_END_UNWRITTEN;
> -				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +			if (io) {
> +				if (!(io->flag & EXT4_IO_END_UNWRITTEN)) {
> +					io->flag = EXT4_IO_END_UNWRITTEN;
> +					atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +				}
>  			} else
>  				ext4_set_inode_state(inode,
>  						     EXT4_STATE_DIO_UNWRITTEN);

