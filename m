From: Milan Broz <mbroz@redhat.com>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Date: Mon, 07 Feb 2011 19:29:26 +0100
Message-ID: <4D503A06.3010403@redhat.com>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com> <20110207174552.GC3457@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Matt <jackdachef@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110207174552.GC3457@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/07/2011 06:45 PM, Ted Ts'o wrote:
> On Fri, Feb 04, 2011 at 10:40:47PM +0000, Matt wrote:
>>
>> So that means that the file-corruption which existed until 2.6.37-rc6
>> and got triggered (for me) more easily via "dm crypt: scale to
>> multiple CPUs"
>> is fixed now ?
> 
> Well, a patch exists for it that will be merged into 2.6.38.
> 
>> That should give ext4 a nice speedup for >=2.6.38 :)
> 
> I'm not going to make it be the default for 2.6.38, since it's fairly
> late in the -rc features.  People who want it can explicitly enable it
> using the mount option mblk_io_submit, though.  (And let me know your
> success stories!  :-) I will be enabling it as the default in
> 2.6.39-rc1.

So it was ext4 only bug in ext4_end_bio(),
dm-crypt per-cpu code was just trigger here, right?

Milan
