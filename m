From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Date: Thu, 24 Aug 2017 16:57:27 -0400
Message-ID: <20170824205727.yyhzblj372eyvkde@thunk.org>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
 <20170824160144.GA14287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Randy Dodgen <dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824160144.GA14287-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 24, 2017 at 09:01:44AM -0700, Christoph Hellwig wrote:
> 
> We really need to do the same for ext2 and xfs.  And we really should
> be doing that in common VM code instead of the file system.  See
> my recent xfs synchronous page fault series on the mess the inconsistent
> handling of the FAULT_FLAG_WRITE causes.  I think we just need a new
> FAULT_FLAG_ALLOC or similar for those page faults that needs to
> allocate space instead of piling hacks over hacks, and make sure
> it's only set over the method that will actually do the allocation,
> as the DAX and non-DAX path are not consistent on that.

Yeah, agreed, that's the cleaner way of doing that.  It does mean
we'll have sweep through all of the file systems so that they DTRT
with this new FAULT_FLAG_ALLOC, though, right?

						- Ted
