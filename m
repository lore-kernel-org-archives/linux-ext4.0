From: david@lang.hm
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Mon, 31 Aug 2009 12:11:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908311209500.6822@asgard.lang.hm>
References: <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>
 <20090831131626.GA17325@infradead.org> <4A9BCEA8.9080206@redhat.com> <alpine.DEB.2.00.0908310847530.6822@asgard.lang.hm> <20090831183154.GB3620@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>, Pavel Machek <pavel@ucw.cz>,
	Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:43703 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbZHaTMi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 15:12:38 -0400
In-Reply-To: <20090831183154.GB3620@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 31 Aug 2009, Christoph Hellwig wrote:

> On Mon, Aug 31, 2009 at 08:50:53AM -0700, david@lang.hm wrote:
>>> It would also be very useful to have all of our top tier file systems
>>> enable barriers by default, provide consistent barrier on/off mount
>>> options and log a nice warning when not enabled....
>>
>> most people are not willing to live with unbuffered write performance.
>
> I'm not sure what you mean with unbuffered write support, the only
> common use of that term is for userspace I/O using the read/write
> sysctem calls directly in comparism to buffered I/O which uses
> the stdio library.
>
> But be ensure that the use of barriers and cache flushes in fsync does not
> completely disable caching (or "buffering"), it just does flush flushes
> the disk write cache in case we either commit a log buffer than need to
> be on disk, or performan an fsync where we really do want to have data
> on disk instead of lying to the application about the status of the
> I/O completion.  Which btw could be interpreted as a violation of the
> Posix rules.

as I understood it, the proposal that I responded to was to change the 
kernel to detect if barriers are enabled for the entire stack or not, and 
if not disable the write caches on the drives.

there are definantly times when that is the correct thing to do, but I 
am not sure that it is the correct thing to do by default.

David Lang
