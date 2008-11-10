From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch 02/23] ext: Avoid printk floods in the face of	directory
 corruption (CVE-2008-3528)
Date: Mon, 10 Nov 2008 12:14:04 -0600
Message-ID: <491879EC.5000204@redhat.com>
References: <20081107224818.593212310@mini.kroah.org> <20081107231516.GC1108@kroah.com> <49179F8C.4050103@redhat.com> <20081110180656.GA9795@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eugene Teo <eteo@redhat.com>, linux-kernel@vger.kernel.org,
	stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eugene Teo <eugeneteo@kernel.sg>
To: Greg KH <gregkh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59133 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYKJSQi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Nov 2008 13:16:38 -0500
In-Reply-To: <20081110180656.GA9795@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg KH wrote:
> On Mon, Nov 10, 2008 at 10:42:20AM +0800, Eugene Teo wrote:
>> Greg KH wrote:
>>
>> Please change the description of the bug to:
>>
>> "A very large directory with many read failures (either due to storage
>> problems, or due to invalid size & blocks from corruption) will generate
>> a printk storm as the filesystem continues to try to read all the
>> blocks. This flood of messages can tie up the box until it is complete -
>> which may be a very long time, especially for very large corrupted values.
>>
>> This is fixed by only reporting the corruption once each time we try to
>> read the directory."
>>
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commitdiff;h=bd39597
> 
> Hm, why would I change the description to be different from what the
> developer asked it to be?  It references the specific changeset you
> point to above already.  I'm inclined to stick with the text that the
> developer asked to be used (especially as this is a combined 3
> changesets into one patch).

There were 3 changesets upstream, one for each fs; I copied the
changelog from the ext4 changeset because it's the patch that I
originally authored, and combined it with the ext2 & ext3 changes as well.

The upstream ext4 changelog happened to contain some color commentary
from Ted; the ext2 & ext3 changelogs did not.

I don't really give a damn what the stable changelog says, and
personally my feelings won't be hurt with either text, I'll just be
happy to have the bug fixed in -stable.

Thanks,
-Eric
