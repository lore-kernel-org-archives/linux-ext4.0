From: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Date: Mon, 29 Jun 2009 17:15:36 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0906291714520.21956@gentwo.org>
References: <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>
 <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int> <20090625220504.GG6472@mit.edu> <4A43F60D.2040801@redhat.com> <20090626011155.GI6472@mit.edu> <Pine.LNX.4.64.0906260815260.18724@melkki.cs.Helsinki.FI>
 <4A44DE14.2080403@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	arjan@infradead.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758840AbZF2VQD@vger.kernel.org>
In-Reply-To: <4A44DE14.2080403@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 26 Jun 2009, Eric Sandeen wrote:

> I'll test it; it'd be great if it did, I'm um, a bit ashamed at how I
> fixed it ;)

Isnt the problem that the slab allocator did not align something that
you did not request to be aligned?
