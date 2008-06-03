From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext2 : Remove redundant condition in ext2_free_blocks()
Date: Tue, 3 Jun 2008 18:58:43 +0530
Message-ID: <ea11fea30806030628y58a13b6bv924ada281c55defe@mail.gmail.com>
References: <ea11fea30805311156o3715d3f9ibd4ea8b44a8f3223@mail.gmail.com>
	 <919fe2b30806030533yce91ceds67b942f3adf88afb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: "Mark Asselstine" <asselsm@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <919fe2b30806030533yce91ceds67b942f3adf88afb@mail.gmail.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 3, 2008 at 6:03 PM, Mark Asselstine <asselsm@gmail.com> wrote:
> On Sat, May 31, 2008 at 2:56 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>> For two unsigned values the check "block+count < block"  is always
>> false. Thus the below patch removes that condition.
>>
> Always? What about "ULONG_MAX + 5"? I believe the answer is 4, but I
> may be wrong. You might want to rethink this one.

Yeah.... it is a total crap patch .... sorry for making the noise.

>
> RE/
> Mark
>
>> =============================================================
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>>
>> --- a/fs/ext2/balloc.c  2008-05-11 23:54:40.000000000 +0530
>> +++ b/fs/ext2/balloc.c  2008-06-01 00:03:44.000000000 +0530
>> @@ -499,7 +499,6 @@
>>        unsigned freed = 0, group_freed;
>>
>>        if (block < le32_to_cpu(es->s_first_data_block) ||
>> -           block + count < block ||
>>            block + count > le32_to_cpu(es->s_blocks_count)) {
>>                ext2_error (sb, "ext2_free_blocks",
>>                            "Freeing blocks not in datazone - "
>>
>>
>> =============================================================
>>
>> --
>> Thanks & Regards,
>> ********************************************
>> Manish Katiyar ( http://mkatiyar.googlepages.com )
>> 3rd Floor, Fair Winds Block
>> EGL Software Park
>> Off Intermediate Ring Road
>> Bangalore 560071, India
>> ***********************************************
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
