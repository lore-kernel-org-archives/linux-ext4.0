From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Thu, 6 Nov 2008 12:33:27 -0500
Message-ID: <20081106173327.GF18939@mit.edu>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Staubach <staubach@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081106163846.GA1381@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 06, 2008 at 11:38:46AM -0500, Christoph Hellwig wrote:
> 
> Yes.  And if someone ran sparse over the code both the initial error
> and this varaint would be trivial to spot..
> 

That's how Aneesh found it.  :-)

					- Ted
