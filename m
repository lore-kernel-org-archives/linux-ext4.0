From: Ric Wheeler <ric@emc.com>
Subject: Re: Shred mount option for ext4?
Date: Wed, 01 Nov 2006 11:38:44 -0500
Message-ID: <4548CD94.2030406@emc.com>
References: <Pine.GSO.4.53.0610311444550.4220@compserv1> <20061101161700.GA5212@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nikolai Joukov <kolya@cs.sunysb.edu>,
	Erik Mouw <erik@harddisk-recovery.com>,
	Samuel Tardieu <sam@rfc1149.net>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:63968 "EHLO
	mexforward.lss.emc.com") by vger.kernel.org with ESMTP
	id S2992648AbWKAQj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Nov 2006 11:39:27 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061101161700.GA5212@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:

>On Oct 31, 2006  15:14 -0500, Nikolai Joukov wrote:
>  
>
>>1. One of the patches performs N overwrites with configurable patterns
>>(can comply with NIST and NISPOM standards).  Because of the transaction
>>compaction we had to separately add overwriting as separate transactions.
>>Fortunately, the whole procedure is still atomic due to the orphan list.
>>The problem that we have right now is per-file syncing of dirty data
>>buffers between overwrites.  We sync the whole device at the moment.
>>    
>>
>
>Did anyone discuss doing this with crypto instead of actually overwriting
>the whole file?  It would be pretty easy to store a per-file crypto key
>in each inode as an EA, then to "delete" the file all that would be
>needed would be to erase the key in a secure matter (which is a great
>deal easier because inodes don't move around on disk).
>  
>
This is an interesting idea with some annoying implementation details. 
For example, we would still need to "shred" that data block used to 
store the EA in order to prevent key recovery.

Also interesting to note that various people are putting encryption into 
various offload parts which could be useful in this context.

>The drawback is there is a runtime overhead to encrypt/decrypt the file
>data, but honestly, if people care about secure deletion don't they also
>care about security of the undeleted data also?  By having an (unknown
>to the user) per-file crypto key then if the file is deleted the user
>can also plausibly deny the ability to recover the file data even if
>they are forced to surrender their key.
>
>Cheers, Andreas
>--
>
>  
>
I think that having the data encrypted on disk is a generically useful 
feature, but in this case it might not count for much since the key is 
stored right next to the data in that EA...

ric
