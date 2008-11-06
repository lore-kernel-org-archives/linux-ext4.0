From: Peter Staubach <staubach@redhat.com>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Thu, 06 Nov 2008 11:06:25 -0500
Message-ID: <49131601.50407@redhat.com>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200811061651.49602.borntraeger@de.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christian Borntraeger wrote:
> Ok, I think I found it:
>
> On big endianess plattforms newly created ext4 file systems cannot be mounted
> and show messages like:
> [6923911.715968] EXT4-fs: not enough memory for 522250 flex groups
> [6923911.715973] EXT4-fs: unable to initialize flex_bg meta info!
>
> We have to access s_reserved_gdb_blocks with le16_to_cpu.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  fs/ext4/super.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: kvm/fs/ext4/super.c
> ===================================================================
> --- kvm.orig/fs/ext4/super.c
> +++ kvm/fs/ext4/super.c
> @@ -1455,7 +1455,7 @@ static int ext4_fill_flex_info(struct su
>  
>  	/* We allocate both existing and potentially added groups */
>  	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
> -			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
> +			    (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks + 1) <<
>   

I suspect that you want to do the le16_to_cpu() and _then_
add the 1.  Otherwise, adding 1 to a different byte order
value won't do quite what is expected or hoped for...

       ps

>  			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
>  			   groups_per_flex;
>  	sbi->s_flex_groups = kzalloc(flex_group_count *
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

