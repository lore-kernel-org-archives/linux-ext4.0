From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Thu, 6 Nov 2008 20:48:05 +0300
Message-ID: <20081106174805.GA24393@x200.localdomain>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org> <20081106173327.GF18939@mit.edu> <20081106173944.GA23398@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Peter Staubach <staubach@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081106173944.GA23398@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 06, 2008 at 12:39:44PM -0500, Christoph Hellwig wrote:
> On Thu, Nov 06, 2008 at 12:33:27PM -0500, Theodore Tso wrote:
> > On Thu, Nov 06, 2008 at 11:38:46AM -0500, Christoph Hellwig wrote:
> > > 
> > > Yes.  And if someone ran sparse over the code both the initial error
> > > and this varaint would be trivial to spot..
> > > 
> > 
> > That's how Aneesh found it.  :-)
> 
> Heh, okay.  We really should try to find some annotations that run
> sparse with endian checking by default for those parts of the tree
> where it makes sense..

In fact endian warnings were off by default, because there were too much of
them in networking stack and elsewhere, but situations definitely improved.
Out of head, only drivers/ieee1394/ is not done.
