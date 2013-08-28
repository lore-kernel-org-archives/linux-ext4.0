From: Tao Ma <tm@tao.ma>
Subject: Re: there is a BUG in disk full case in inlinedata feature.
Date: Wed, 28 Aug 2013 09:04:50 +0800
Message-ID: <521D4CB2.2060805@tao.ma>
References: <CAAFszuVts-gn85SqPje=dibGFVo9GH6RKSJiOP6KtkZTgdDYNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>, Theodore Tso <tytso@mit.edu>,
	"lewis.liulei" <lewis.liulei@huawei.com>
To: Boxi Liu <boxi10liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9-pub.mail.unifiedlayer.com ([69.89.24.6]:35413 "HELO
	oproxy9-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753051Ab3H1BFB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Aug 2013 21:05:01 -0400
In-Reply-To: <CAAFszuVts-gn85SqPje=dibGFVo9GH6RKSJiOP6KtkZTgdDYNQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Boxi,
	Thanks for the detailed explanation and the bug fix. It looks good to me.
	So would you mind send out a formal patch?

Thanks,
Tao
On 08/28/2013 01:09 AM, Boxi Liu wrote:
> there is a BUG in EXT4 inlinedata feature when the disk is full(0B).
> tast case:
>     step1: use the dd to make the disk full,has 0B remained.
>     step2: touch a inlinedata file
>            echo -n "123456" >> test.txt
>     step3: make the inlinedata file test.txt convert to extent block.
>            echo -n
> "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890">>test.txt
> the step3 will write failed.and print the BUG Backtrace:
> page:c1963bc0 count:-1 mapcount:0 mapping: (null) index:0x0
> page flags:0x40000000()
> Backtrace:
> [<c004e180>] (dump_backtrace + 0x0/0x12c) from [<c07724ac>]
> (dump_stack +0x18/0x1c)
> r6:c0043a84  r5:c0bb688  r4:c1963bc0 r3:00000000
> [<c0772494>] (dump_stack + 0x0/0x1c) from [<c00f6dd4>] (bad_page + 0xbc/0x13c)
> [<c00fbd18>] (bad_page + 0x0/0x13c) from [<c00f74b80>]
> (get_page_from_freelist + 0x4cc/0xb6c)
> r7:c1963bd8 r6:c0043194 r5:c1963bc0 r4:00000001
> [<c00f6fec>] (get_page_from_freelist +0x0/0xb6c) from [<c00f8148>]
> (__alloc_pages_nodemask + 0x144/0x820)
> [<c00f8004>] (__alloc_pages_nodemask +0x0/0x820) from [<c0115250>]
> (handle_pte_fault + 0x574/0x758)
> [<c0114cdc>] (handle_pte_fault + 0x0/0x758) from [<c0115500>]
> (handle_mm_fault + 0xcc/0x110)
> [<c0115434>] (handel_mm_fault + 0x0/0x110) from [<c00521a8>]
> (do_page_fault + 0x16c/0x1f4)
> [<c005203c>] (do_page_fault + 0x0/0x1f4) from [<c00440d0>]
> (do_DataAbort + 0x40/0xac)
> [<c0044090>] (do_DataAbort + 0x0/0xac) from [<c004a064>]
> (ret_from_exception + 0x0/0x10)
> 
> And when the system reboot , the step2 data "123456" will alse lost.
> You can cat the test.txt,but there is no data in the file.
> the reason is when the inlinedata convert to extent in the limit case,
> the inlinedata read to the page,then destory the inlinedata,next step
> is to __block_write_begin,but it can't get block,return -ENOSPC. so
> the data lost.
> 
> there is a patch may fix the bug:
> in inline.c ext4_convert_inline_data_to_extent
> 
>          needed_blocks = ext4_writepage_trans_blocks(inode);
> 
> +        if(EXT4_C2B(sbi,percpu_counter_read_positive(&sbi->s_freeclusters_counter))
> < needed_blocks)
> +               return -ENOSPC;
> +
>          ret = ext4_get_inode_loc(inode, &iloc);
>          if (ret)
>                  return ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

