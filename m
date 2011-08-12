From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Fri, 12 Aug 2011 14:13:30 -0400
Message-ID: <20110812181330.GG31181@thunk.org>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com>
 <BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca>
 <alpine.LFD.2.00.1108121013280.4535@dhcp-27-109.brq.redhat.com>
 <4E44E374.7080103@redhat.com>
 <CAO81RMYcvpd2--Y-u2xOb2+3U=fOK2UtaW7d9iP43_u38hYgZA@mail.gmail.com>
 <alpine.LFD.2.00.1108121803210.3088@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52980 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab1HLSNh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 14:13:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1108121803210.3088@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 12, 2011 at 06:08:21PM +0200, Lukas Czerner wrote:
> On Fri, 12 Aug 2011, Curt Wohlgemuth wrote:
> 
> > I don't know much about data=journal, but I've been running xfstests
> > with it, and it's a disaster, given that data=journal doesn't support
> > O_DIRECT.  What kind of testing do people do on data=journal?

I have a rather long list of expected failures, mostly having to do
with xfstests assuming that O_DIRECT has to be supported.  On my todo
list is to scrub through the list failures that I've seen, make sure
they are indeed related to O_DIRECT, and then see if I can figure out
some way of telling xfstests to skip O_DIRECT tests via some
environment variable or command line option.

For the record this is what I mostly expect (from a somewhat older
xfstests) in the data=journal case:

Ran: 001 002 005 006 007 011 013 014 053 069 070 074 075 076 077 088 089 100 105 112 113 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 256
Failures: 113 125 130 133 135 198 207 208 209 210 214 223 226 239 240 245

BTW, with the very latest xfstests, I'm seeing new across-the-board
(not just data=journal) failures for tests #62 (caused by the presence
of the lost+found directory and differences in error code returns for
xattrs) and #79 (a failure in the append-only handling which I don't
completely understand yet).

> Short answer is probably none :). Even though that it seems like an
> radical answer I believe that it is mostly true, because simply said
> almost no-one care. But I think that Ted mentioned that he actually do
> some tests with that mode, but I am not sure about that.

Yes, I'm testing with data=journal, and I haven't been able to
reproduce the crash which curtw is seeing (see above; test #74 passes
in my 2cpu/512mb KVM test environment).  I'll add some instrumentation
to the BUG_ON in question and then try to reproduce it in curtw's
environment.

							- Ted
