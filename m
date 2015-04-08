From: walter harms <wharms@bfs.de>
Subject: Re: [patch] ext4 crypto: testing the wrong variable
Date: Wed, 08 Apr 2015 13:51:08 +0200
Message-ID: <5525162C.3020808@bfs.de>
References: <20150408085338.GA8837@mwanda> <alpine.DEB.2.10.1504081150401.9503@hadrien>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Michael Halcrow <mhalcrow@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1504081150401.9503@hadrien>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Am 08.04.2015 11:51, schrieb Julia Lawall:
>>  void ext4_fname_crypto_free_buffer(void **buf)
>>  {
>> -	if (*buf == NULL || IS_ERR(buf))
>> +	if (*buf == NULL || IS_ERR(*buf))
> 
> Why not use IS_ERR_OR_NULL?
> 
> julia


why test *buf == NULL ? xfree() can handle this.

the question is do programm depend on *buf=NULL.
In case of IS_ERR(*buf) *buf will be left unchanged
and later prgramms may things there is a buffer
available ?

> 
>>  		return;
>>  	kfree(*buf);
>>  	*buf = NULL;
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
