From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Thu, 6 Nov 2008 18:11:44 +0100
Message-ID: <200811061811.44802.borntraeger@de.ibm.com>
References: <200811061600.54264.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Peter Staubach <staubach@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081106163846.GA1381@infradead.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Donnerstag, 6. November 2008 schrieb Christoph Hellwig:
> > I suspect that you want to do the le16_to_cpu() and _then_
> > add the 1.  Otherwise, adding 1 to a different byte order
> > value won't do quite what is expected or hoped for...
> 
> Yes.  And if someone ran sparse over the code both the initial error
> and this varaint would be trivial to spot..

I think the problem is, that sparse now requires
__CHECK_ENDIAN__
to check for endianess problems. Seems that lots of people are not aware of 
this.

Christian
