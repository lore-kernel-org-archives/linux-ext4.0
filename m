From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: [RFC][PATCH 0/3] ext4 online defrag (ver 0.2)
Date: Wed, 17 Jan 2007 20:23:27 +0900
Message-ID: <02bb01c73a29$eb846120$4168010a@bsd.tnes.nec.co.jp>
References: <20070116210346sho@rifu.tnes.nec.co.jp> <20070116192134.GB5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: "Joel Becker" <Joel.Becker@oracle.com>,
	"Andreas Dilger" <adilger@clusterfs.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

> On Jan 16, 2007  21:03 +0900, sho@tnes.nec.co.jp wrote:
>> 1. Add new ioctl(EXT4_IOC_DEFRAG) which returns the first physical
>>    block number of the specified file.  With this ioctl, a command
>>    gets the specified directory's.
>
> Maybe I don't understand, but how is this different from the long-time
> FIBMAP ioctl?

I can use FIBMAP instead of my new ioctl.
You are right.  I should have used FIBMAP ioctl...

>> struct ext4_ext_defrag_data {
>>         loff_t start_offset; /* start offset to defrag in byte */
>>         loff_t defrag_size;  /* size of defrag in bytes */
>> ext4_fsblk_t goal;   /* block offset for allocation */
>> };
>
> Two things of note:
> - presumably the start_offset and defrag_size should be multiples of the
>  filesystem blocksize?  If they are not, is it an error or are they
>  adjusted to cover whole blocks?

Given the value which isn't multiples of the blocksize,
they are adjusted to cover whole blocks in the kernel.

But I think that it isn't clean that the unit of goal is different from
start_offset and defrag_size.  I will change their unit into a blocksize
in the next update.

> - in previous defrag discussions (i.e. XFS defrag), it was desirable to
>  allow specifying different types of goals (e.g. hard, soft, kernel picks).
>  We may as well have a structure that allows these to be specified, instead
>  of having to change the interface afterward.

Let me see...  Is it the following discussion?
http://marc.theaimsgroup.com/?l=linux-ext4&m=116161490908645&w=2
http://marc.theaimsgroup.com/?l=linux-ext4&m=116184475306761&w=2

Cheers, Takashi
