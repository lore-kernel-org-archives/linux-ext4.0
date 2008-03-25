From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Tue, 25 Mar 2008 11:21:17 +0900
Message-ID: <47E8619D.9020607@rs.jp.nec.com>
References: <200803141202.AA00330@TNESG9526.rs.jp.nec.com> <20080314125848.GE3542@webber.adilger.int> <47DE0F8D.2060106@rs.jp.nec.com> <20080317170846.GE3542@webber.adilger.int> <47E789E6.6000806@rs.jp.nec.com> <47E7C21A.10208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, cmm@us.ibm.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <47E7C21A.10208@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Akira Fujita wrote:
>
>   
>> Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
>> I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
>> in ext4 online defrag when kernel supports it.
>>     
>
> It's not, yet, but I could probably put it there.
>
>   
I see.

> It is not ready for upstream yet at all, but it does have a good amount
> of functionality.
>
> I'll try to get something submitted for the patch queue soon...
>
> (I decided to slow down a bit on the fiemap work, and concentrate on
> helping to get e2fsprogs ready with ext4 support)
>
>   
No problem since e2fsprogs is one of the most important things for ext4.

Regards, Akira
