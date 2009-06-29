From: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Date: Mon, 29 Jun 2009 17:06:37 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0906291703020.21956@gentwo.org>
References: <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>  <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu>  <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>  <20090625203743.GD6472@mit.edu>
 <20090625212628.GO3385@webber.adilger.int>  <20090625220504.GG6472@mit.edu> <4A43F60D.2040801@redhat.com>  <20090626011155.GI6472@mit.edu>  <Pine.LNX.4.64.0906260815260.18724@melkki.cs.Helsinki.FI>  <20090626085629.GC12201@wotan.suse.de>
 <1246006681.27533.22.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nick Piggin <npiggin@suse.de>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	arjan@infradead.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755073AbZF2VHP@vger.kernel.org>
In-Reply-To: <1246006681.27533.22.camel@penberg-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 26 Jun 2009, Pekka Enberg wrote:

> Yes, but AFAICT, SLUB_DEBUG doesn't respect the given alignment without
> my patch.

The size parameter to calculate_alignment has no relevance unless the size
is smaller than half of the alignment. Then for some reason we do not
properly align the stuff. I never liked that....
