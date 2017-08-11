From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Date: Fri, 11 Aug 2017 03:03:27 -0700
Message-ID: <20170811100327.GD7064@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz>
 <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
 <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

T24gTW9uLCBBdWcgMDcsIDIwMTcgYXQgMDU6MjQ6MDhQTSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOgo+IERvZXMgc3lzX21tYXAoKSByZWplY3QgdW5rbm93biBmbGFnIHZhbHVlcyB0b2RheT8g
SSdtIGVpdGhlciBub3QKPiBsb29raW5nIGluIHRoZSByaWdodCBwbGFjZSBvciBpdCdzIG1pc3Np
bmcgYW5kIHdlJ2xsIG5lZWQgc29tZQo+IGludGVyZmFjZS9tZWNoYW5pc20gdG8gY2hlY2sgaWYg
TUFQX1NZTkMgaXMgaG9ub3JlZC4KCkl0IGRvZXNuJ3Qgc2VlbSB0byByZWplY3QgdW5rbm93biBm
bGFncy4KClRoZSBsYWNrIG9mIGZsYWdzIGNoZWNraW5nIHN0cmlrZXMgYmFjayBvbmNlIG1vcmUs
IHNpZ2jhuasuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRw
czovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
