From: Dhaval Giani <dgiani@mozilla.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Thu, 25 Jul 2013 15:27:19 -0400
Message-ID: <51F17C17.2010702@mozilla.com>
References: <1374699833.7083.2.camel@localhost> <20130724233628.GD3641@logfs.org> <51F14136.30409@mozilla.com> <51F1556A.20909@mozilla.com> <20130725175307.GA15590@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org,
	tytso@mit.edu, vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130725175307.GA15590@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013-07-25 1:53 PM, J=C3=B6rn Engel wrote:
> On Thu, 25 July 2013 09:42:18 -0700, Taras Glek wrote:
>> Footprint wins are useful on android, but it's the
>> increased IO throughput on crappy storage devices that makes this
>> most attractive.
> All the world used to be a PC.  Seems to be Android these days.
>
> The biggest problem with compression support in the past was the
> physical properties of hard drives (the spinning type, if you can
> still remember those).  A random seek is surprisingly expensive, of a
> similar cost to 1MB or more of linear read.  So anything that
> introduces more random seeks will kill the preciously little
> performance you had to begin with.
>
> As long as files are write-once and read-only from that point on, you
> can just append a bunch of compressed chunks on the disk and nothing
> bad happens.  But if you have a read-write file with random overwrite=
s
> somewhere in the middle, those overwrites will change the size of the
> compressed data.  You have to free the old physical blocks on disk an=
d
> allocate new ones.  In effect, you have auto-fragmentation.
>
> So if you want any kind of support for your approach, I suspect you
> should either limit it to write-once files or prepare for a mob of
> gray-haired oldtimers with rainbow suspenders complaining about
> performance on their antiquated hardware.  And the mob may be larger
> than you think.

Yes, we plan to limit it to write-once. In order to write, you have to
replace the file.

Dhaval
