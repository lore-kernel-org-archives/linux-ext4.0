From: SeongJae Park <sj38.park@gmail.com>
Subject: Re: [PATCH] Documentation: Fix dead URLs to ftp.kernel.org
Date: Mon, 27 Mar 2017 22:04:06 +0900
Message-ID: <CAEjAshpG7XXZgjuvau6v_hCNBJRqX7C2ODBqWQbZyCHegu9=Xg@mail.gmail.com>
References: <20170326142550.29269-1-sj38.park@gmail.com> <20170326131115.1399a01c@lwn.net>
 <20170327094936.6578346d@vento.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jonathan Corbet <corbet@lwn.net>, "Theodore Ts'o" <tytso@mit.edu>,
        adilger.kernel@dilger.ca, jeffrey.t.kirsher@intel.com,
        mchehab@kernel.org, linux-doc <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170327094936.6578346d@vento.lan>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 27, 2017 at 9:49 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Sun, 26 Mar 2017 13:11:15 -0600
> Jonathan Corbet <corbet@lwn.net> escreveu:
>
>> On Sun, 26 Mar 2017 23:25:50 +0900
>> SeongJae Park <sj38.park@gmail.com> wrote:
>>
>> CC += davem
>>
>> If nobody objects, I'll just take this through the docs tree.
>
> I have just one comment. See below.
>
>> > diff --git a/Documentation/filesystems/nfs/nfs-rdma.txt b/Documentation/filesystems/nfs/nfs-rdma.txt
>> > index 1e6564545edf..31b55fe434d3 100644
>> > --- a/Documentation/filesystems/nfs/nfs-rdma.txt
>> > +++ b/Documentation/filesystems/nfs/nfs-rdma.txt
>> > @@ -113,7 +113,7 @@ Installation
>> >      kernel version 2.6.25 and later. This and other versions of the 2.6 Linux
>> >      kernel can be found at:
>> >
>> > -    ftp://ftp.kernel.org/pub/linux/kernel/v2.6/
>> > +    https://www.kernel.org/pub/linux/kernel/v2.6/
>
> I would change it to:
>
>     ...
>     The NFS/RDMA client and server are both included in the mainline Linux
>     kernel version 2.6.25 and later. This and other versions of the Linux
>     kernel can be found at:
>
>         https://www.kernel.org/pub/linux/kernel/
>
> After such fix, feel free to add:
>
> Reviewed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thank you for the comment.  I will send the comment applied version as a reply
to this mail soon.


Thanks,
SeongJae Park

>
> Thanks,
> Mauro
