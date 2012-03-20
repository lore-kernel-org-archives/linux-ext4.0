From: david@lang.hm
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 18:28:17 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1203191826100.22704@asgard.lang.hm>
References: <cover.1331856299.git.joe@perches.com> <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com> <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop> <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>
 <171703.1332178579@turing-police.cc.vt.edu> <1332179050.3341.7.camel@joe2Laptop> <20120320010606.GC14363@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Joe Perches <joe@perches.com>, Valdis.Kletnieks@vt.edu,
	Jiri Slaby <jirislaby@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120320010606.GC14363@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 19 Mar 2012, Ted Ts'o wrote:

> On Mon, Mar 19, 2012 at 10:44:10AM -0700, Joe Perches wrote:
>>
>> This stuff ain't whitespace.
>>
>
> I'll have to respectfully disagree with you.  For ext4, as far as I am
> concerned, changing printk(KERN_INFO, ...) to pr_info(...) is *purely*
> a whitespace-level change.

Joe, if everything did change, what difference would it make?

just being a consistant style doesn't matter much, but if there is some 
functionality that would be possible with pr_info(...) that would not be 
possible with printk(KERN_INFO, ...), there may be more reason to change.

David Lang
