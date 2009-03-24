From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Tue, 24 Mar 2009 21:27:35 +1100
Message-ID: <200903242127.36541.nickpiggin@yahoo.com.au>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090319164638.GB3899@duck.suse.cz> <200903241844.22851.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
	Ying Han <yinghan@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>, guichaz@gmail.com,
	Alex Khesin <alexk@google.com>,
	Mike Waychison <mikew@google.com>,
	Rohit Seth <rohitseth@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:37802 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756975AbZCXK1r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Mar 2009 06:27:47 -0400
In-Reply-To: <200903241844.22851.nickpiggin@yahoo.com.au>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 24 March 2009 18:44:21 Nick Piggin wrote:

> I close my eyes and pick something out of a hat. a686cd89. Search for XXX.
> Nice. Whether or not this cased the problem, can someone please tell me
> why it got merged in that state?

Actually I must be wrong about this if the problem was reproduced in
2.6.18. Question still stands, though.

