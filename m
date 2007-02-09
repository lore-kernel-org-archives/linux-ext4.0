From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: [RFC][PATCH 3/3] Online defrag command
Date: Fri, 9 Feb 2007 17:08:50 +0900
Message-ID: <071601c74c21$8b75bf90$4168010a@bsd.tnes.nec.co.jp>
References: <20070208180235sho@rifu.tnes.nec.co.jp> <20070208135620.GF4487@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
To: "Jens Axboe" <jens.axboe@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

> On Thu, Feb 08 2007, Takashi Sato wrote:
>> The defrag command.  Usage is as follows:
>> o Put the multiple files closer together.
>>   # e4defrag -r directory-name
>> o Defrag for a single file.
>>   # e4defrag file-name
>> o Defrag for all files on ext4.
>>   # e4defrag device-name
>
> Would it be possible to provide support for putting multiple files close
> together? Ala
>
> # e4defrag file1 file2 file3 ... fileN

e4defrag cannot do it in my current implementation.
I will consider its implementation on my later version.

Alternatively, you can do it if you link those files with a directory.
# ln file1 file2 file3 ... fileN directory-name
# e4defrag -r directory-name

> I'm thinking boot speedup, gather the list of read files and put them
> close on disk.

I think so.  It's my final goal.

Cheers, Takashi
