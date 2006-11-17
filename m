From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: [RFC][PATCH 0/3] Extent base online defrag
Date: Fri, 17 Nov 2006 21:39:50 +0900
Message-ID: <0e7101c70a45$7c28d360$4168010a@bsd.tnes.nec.co.jp>
References: <20061109200950sho@rifu.tnes.nec.co.jp> <45532328.70302@garzik.org> <1163081503.10671.9.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
	"Jeff Garzik" <jeff@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

>> > - Specify the target area in a file using the following structure:
>> >   struct ext3_ext_defrag_data {
>> >   loff_t start_offset; /* start offset to defrag in bytes */
>> >   loff_t defrag_size;  /* size of defrag in bytes */
>> >   }
>> >   It uses loff_t so that the size of the structure is identical on
>> >   both 32 bits and 64 bits architecture.
>> >   Block allocation, including searching for the free contiguous
>> >   blocks, is implemented in kernel.
>> 
>> NAK the ioctl approach.
> 
> I agree it shouldn't go into mainline this way, but while the details of
> the proper interface are debated, this implementation at least allows
> the core function to be tested & reviewed.
> 
>> People who like ioctls are just holdovers from non-Linux OS's.

Thank you for your comments.
My patches are at the experimental phase and the ioctl approach is
the provisional solution.
But I intend to continue this work with ioctl approach, if there are no
actual problems.

Cheers, Takashi
