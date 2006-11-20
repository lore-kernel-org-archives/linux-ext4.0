From: Rupesh Thakare <rupesh@clusterfs.com>
Subject: Re: Shred mount option for ext4?
Date: Mon, 20 Nov 2006 16:22:12 +0530
Message-ID: <456188DC.5030107@clusterfs.com>
References: <8C7C41A176AC0B468BEFB2EFD9BDAB9902426639@XCH-NW-5V2.nw.nos.boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Nikolai Joukov <kolya@cs.sunysb.edu>,
	Erik Mouw <erik@harddisk-recovery.com>,
	Samuel Tardieu <sam@rfc1149.net>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:6581 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1755784AbWKTKwT
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Nov 2006 05:52:19 -0500
To: "Wolber, Richard C" <richard.c.wolber@boeing.com>
In-Reply-To: <8C7C41A176AC0B468BEFB2EFD9BDAB9902426639@XCH-NW-5V2.nw.nos.boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Wolber, Richard C wrote:
>> On Wednesday, November 01, 2006 8:17 AM Andreas Dilger Wrote:
>>
>> Did anyone discuss doing this with crypto instead of actually 
>> overwriting the whole file?  It would be pretty easy to store 
>> a per-file crypto key in each inode as an EA, then to 
>> "delete" the file all that would be needed would be to erase 
>> the key in a secure matter (which is a great deal easier 
>> because inodes don't move around on disk).
>>     
>
> If it's cheap to delete the keys, it's also cheap to harvest 
> the keys. A per file crypto-key lowers the barrier to entry.
>   
That's true. But can't we combine the advantages of single-secure-key 
and per-file krypto key ?
Can't we have a half single-secure-key combined with half 
per-file-krypto ? Key management overhead is not
worse than that for single-secure-key. This gives offers same security 
with ease for shredding.

Cheers,
Rupesh
> This is Schneier 101.
>
>
> ..Chuck..
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
