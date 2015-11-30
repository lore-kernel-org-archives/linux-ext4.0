From: Elmar Stellnberger <estellnb@elstel.org>
Subject: Re: [PATCH 01/12] Ext4: Fix extended timestamp encoding and decoding
Date: Mon, 30 Nov 2015 15:46:06 +0100
Message-ID: <565C612E.70804@elstel.org>
References: <20151120145422.18930.72662.stgit@warthog.procyon.org.uk>
 <3495329.crWmoA5ACn@wuerfel> <20151129024555.GA31968@thunk.org>
 <2872067.shHdUXoF07@wuerfel> <20151130141605.GA4316@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
	David Howells <dhowells@redhat.com>, linux-afs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151130141605.GA4316@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 30.11.2015 15:16, Theodore Ts'o wrote:
> On Sun, Nov 29, 2015 at 10:30:39PM +0100, Arnd Bergmann wrote:
>> The other large missing piece is the system call implementation. I have
>> posted a series earlier this year before my parental leave, and it's
>> currently lacking review from libc folks, and blocked on me to update
>> the series and post it again.
>
> I assume that this also means there hasn't been much thought about
> userspace support above libc?  i.e., how to take a 64-bit time64_t (or
> changing the size of time_t) and translating that to a string using
> some kind of version of ctime() and asctime(), and how to parse a
> post-2038 date string and turning it into a 64-bit time_t on a 32-bit
> platform?
>

   Arnd, I would just like to tell you how much I welcome your decision 
for a new __kernel_time64_t!
   As a time[64]_t is basically well defined counting artificial seconds 
since the epoch (1970-01-01 00:00) where every year divisible by four is 
a leap year that is for the meanwhile already sufficient to make use of 
your new type. I just think about the Mayan calendar application which I 
have implemented last year (Though I have not brought it to a 
publishable state yet). A single typedef should be sufficient to let it 
make use of time64_t (it directly uses this type as well as long long 
internally for its calculations rather than the glibc time format 
functions).
