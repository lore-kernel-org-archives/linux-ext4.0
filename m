From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [RFC PATCH v2 18/21] ext4: add support for read_iter and write_iter
Date: Mon, 02 Apr 2012 19:11:28 -0500
Message-ID: <4F7A4030.5020701@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-19-git-send-email-dave.kleikamp@oracle.com> <20120402184204.GE2880@thunk.org> <4F7A2BFE.8000609@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:20085 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2DCALh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2012 20:11:37 -0400
In-Reply-To: <4F7A2BFE.8000609@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/02/2012 05:45 PM, Dave Kleikamp wrote:
> On 04/02/2012 01:42 PM, Ted Ts'o wrote:
>> On Fri, Mar 30, 2012 at 10:43:45AM -0500, Dave Kleikamp wrote:
>>> use the generic .read_iter and .write_iter functions
>>
>> Potentially silly question --- why not use NULL pointer to mean
>> generic_file_read_iter and generic_file_write_iter?  Then you won't
>> have to patch a bunch of file systems to add the generic .read_iter
>> and .write_iter?
> 
> I'm  not very confident that generic_file_read_iter and
> generic_file_write_iter will work for every filesystem that I haven't
> yet touched. It should work if they use generic_aio_read and _write, but
> some have their own versions of those.

In fact, I just realized a big oversight on my part in that I have ext4
calling generic_file_write_iter(), when in fact, it should be doing the
equivalent of ext4_file_write(). If been chasing a bug assuming that
ext4 called generic_aio_write(). Sometimes I miss the obvious.

> 
> Shaggy
