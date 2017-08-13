From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Date: Sat, 12 Aug 2017 19:44:14 -0700
Message-ID: <CAPcyv4hgqh8tHeWDNRnJnvwDh7hiFU8+3O0VWAHFQOEvPna11Q@mail.gmail.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz> <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
 <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
 <20170811100327.GD7064@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170811100327.GD7064-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
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

T24gRnJpLCBBdWcgMTEsIDIwMTcgYXQgMzowMyBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBp
bmZyYWRlYWQub3JnPiB3cm90ZToKPiBPbiBNb24sIEF1ZyAwNywgMjAxNyBhdCAwNToyNDowOFBN
IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4+IERvZXMgc3lzX21tYXAoKSByZWplY3QgdW5r
bm93biBmbGFnIHZhbHVlcyB0b2RheT8gSSdtIGVpdGhlciBub3QKPj4gbG9va2luZyBpbiB0aGUg
cmlnaHQgcGxhY2Ugb3IgaXQncyBtaXNzaW5nIGFuZCB3ZSdsbCBuZWVkIHNvbWUKPj4gaW50ZXJm
YWNlL21lY2hhbmlzbSB0byBjaGVjayBpZiBNQVBfU1lOQyBpcyBob25vcmVkLgo+Cj4gSXQgZG9l
c24ndCBzZWVtIHRvIHJlamVjdCB1bmtub3duIGZsYWdzLgo+Cj4gVGhlIGxhY2sgb2YgZmxhZ3Mg
Y2hlY2tpbmcgc3RyaWtlcyBiYWNrIG9uY2UgbW9yZSwgc2lnaOG5qy4KCkhvdyBhYm91dCBNQVBf
U1lOQyA9PSAoTUFQX1NIQVJFRHxNQVBfUFJJVkFURSk/IE9uIG9sZGVyIGtlcm5lbHMgdGhhdApz
aG91bGQgZ2V0IC1FSU5WQUwsIGFuZCBvbiBuZXcga2VybmVscyBpdCBtZWFucyBTWU5DK1NIQVJF
RC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgt
bnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlz
dHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
