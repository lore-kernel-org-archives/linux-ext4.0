From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Tue, 06 Mar 2012 01:40:05 +0100
Message-ID: <4F555CE5.7050401@itwm.fraunhofer.de>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <20120305155939.GE21356@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fan Yong <yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org>,
	bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Andreas Dilger <adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org>
To: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120305155939.GE21356-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 03/05/2012 04:59 PM, Ted Ts'o wrote:
> On Mon, Jan 09, 2012 at 02:21:48PM +0100, Bernd Schubert wrote:
>> diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
>> index ac8f168..fa8e491 100644
>> --- a/fs/ext4/hash.c
>> +++ b/fs/ext4/hash.c
>> @@ -200,8 +200,8 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
>>   		return -1;
>>   	}
>>   	hash = hash&  ~1;
>> -	if (hash == (EXT4_HTREE_EOF<<  1))
>> -		hash = (EXT4_HTREE_EOF-1)<<  1;
>> +	if (hash == (EXT4_HTREE_EOF_32BIT<<  1))
>> +		hash = (EXT4_HTREE_EOF_32BIT - 1)<<  1;
>>   	hinfo->hash = hash;
>>   	hinfo->minor_hash = minor_hash;
>>   	return 0;
>
> Is there a reason why we don't need to avoid the collsion with the
> 64-bit EOF value as well?  i.e., I think we also need to add:
>
> 	if (hash == (EXT4_HTREE_EOF_64BIT<<  1))
> 		hash = (EXT4_HTREE_EOF_64BIT - 1)<<  1;
>
> 		       			       	  - Ted


Thanks for looking into it, really appreciated!

Yeah, you are right, we also should check for 64-bit EOF. But wouldn't 
be something like this be better?

	/* check for hash collision */
	if(is_32bit_api() ) {
		if (hash == (EXT4_HTREE_EOF_32BIT<<  1))
			hash = (EXT4_HTREE_EOF_32BIT - 1)<<  1;
	} else {
		if (hash == (EXT4_HTREE_EOF_64BIT<<  1))
			hash = (EXT4_HTREE_EOF_64BIT - 1)<<  1;
	}



Or am I over engineering?


Thanks,
Bernd


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
