From: Nick Alcock <nix@esperi.org.uk>
Subject: Re: repeatable inline-data oops (and fs corruption) caused by msync() of shared writable mmap (with recipe)
Date: Thu, 16 Mar 2017 16:13:01 +0000
Message-ID: <8760j95hf6.fsf@esperi.org.uk>
References: <87y3wqc5we.fsf@esperi.org.uk>
        <20170316153100.GA8224@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org,
        Linux FS Mailing List <linux-fsdevel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170316153100.GA8224@quack2.suse.cz> (Jan Kara's message of
        "Thu, 16 Mar 2017 16:31:00 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 16 Mar 2017, Jan Kara stated:

> On Tue 28-02-17 22:22:25, Nix wrote:
>> I first spotted this -- or it spotted me -- back in the v4.7.x days. It
>> is still present in v4.10.
>> 
>> Here's a replication recipe, given a reasonable rootfs with a compiler
>> on it, and assuming a blank virtio disk on /dev/vdb:
>
> Yup, the problem is that we mmap file with inline data without unpacking
> that and ext4_writepages() is unable to update inline data. Easy fix would
> be to unpack inline data in ext4_page_mkwrite(), somewhat more complicated
> fix would be to unpack inline data when extending file to too large size
> via truncate and handle writing into inode in ext4_writepages(). I'll have
> a look into fixing this. Thanks for report!

You probably want to talk to Eric Biggers, who posted a partial fix a
few days ago: <http://marc.info/?l=linux-ext4&m=148936608506059&w=2>
