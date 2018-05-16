From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/14] mm: turn on vm_fault_t type checking
Date: Wed, 16 May 2018 08:08:29 -0700
Message-ID: <20180516150829.GA4904@magnolia>
References: <20180516054348.15950-1-hch@lst.de>
	<20180516054348.15950-15-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-btrfs@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        linux-mm@kvack.org, ocfs2-devel@oss.oracle.com,
        Souptick Joarder <jrdr.linux@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, devel@lists.orangefs.org,
        lustre-devel@lists.lustre.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <20180516054348.15950-15-hch@lst.de>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

T24gV2VkLCBNYXkgMTYsIDIwMTggYXQgMDc6NDM6NDhBTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gU3dpdGNoIHZtX2ZhdWx0X3QgdG8gcG9pbnQgdG8gYW4gdW5zaWduZWQgaW50
IHdpdGggX19i0ZZ0d2lzZSBhbm5vdGF0aW9ucy4KPiBUaGlzIGJvdGggY2F0Y2hlcyBhbnkgb2xk
IC0+ZmF1bHQgb3IgLT5wYWdlX21rd3JpdGUgaW5zdGFuY2Ugd2l0aCBwbGFpbgo+IGNvbXBpbGVy
IHR5cGUgY2hlY2tpbmcsIGFzIHdlbGwgYXMgZmluZGluZyBtb3JlIGludHJpY2F0ZSBwcm9ibGVt
cyB3aXRoCj4gc3BhcnNlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAbHN0LmRlPgo+IC0tLQoKPFVMVFJBU05JUD4KCkZvciB0aGUgaW9tYXAgYW5kIHhmcyBwYXJ0
cywKUmV2aWV3ZWQtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGFycmljay53b25nQG9yYWNsZS5jb20+
CgpUaGF0IHNhaWQuLi4KCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW1fdHlwZXMuaCBi
L2luY2x1ZGUvbGludXgvbW1fdHlwZXMuaAo+IGluZGV4IDU0ZjFlMDVlY2YzZS4uZGEyYjc3YTE5
OTExIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGludXgvbW1fdHlwZXMuaAo+ICsrKyBiL2luY2x1
ZGUvbGludXgvbW1fdHlwZXMuaAo+IEBAIC0yMiw3ICsyMiw4IEBACj4gICNlbmRpZgo+ICAjZGVm
aW5lIEFUX1ZFQ1RPUl9TSVpFICgyKihBVF9WRUNUT1JfU0laRV9BUkNIICsgQVRfVkVDVE9SX1NJ
WkVfQkFTRSArIDEpKQo+ICAKPiAtdHlwZWRlZiBpbnQgdm1fZmF1bHRfdDsKPiArdHlwZWRlZiB1
bnNpZ25lZCBfX2JpdHdpc2Ugdm1fZmF1bHRfdDsKPiArCj4gIAo+ICBzdHJ1Y3QgYWRkcmVzc19z
cGFjZTsKPiAgc3RydWN0IG1lbV9jZ3JvdXA7Cj4gQEAgLTYxOSw3ICs2MjAsNyBAQCBzdHJ1Y3Qg
dm1fc3BlY2lhbF9tYXBwaW5nIHsKPiAgCSAqIElmIG5vbi1OVUxMLCB0aGVuIHRoaXMgaXMgY2Fs
bGVkIHRvIHJlc29sdmUgcGFnZSBmYXVsdHMKPiAgCSAqIG9uIHRoZSBzcGVjaWFsIG1hcHBpbmcu
ICBJZiB1c2VkLCAucGFnZXMgaXMgbm90IGNoZWNrZWQuCj4gIAkgKi8KPiAtCWludCAoKmZhdWx0
KShjb25zdCBzdHJ1Y3Qgdm1fc3BlY2lhbF9tYXBwaW5nICpzbSwKPiArCXZtX2ZhdWx0X3QgKCpm
YXVsdCkoY29uc3Qgc3RydWN0IHZtX3NwZWNpYWxfbWFwcGluZyAqc20sCgpVaCwgd2UncmUgY2hh
bmdpbmcgZnVuY3Rpb24gc2lnbmF0dXJlcyAvYW5kLyByZWRlZmluaW5pbmcgdm1fZmF1bHRfdD8K
QWxsIGluIHRoZSBzYW1lIDkwSyBwYXRjaD8KCkkgL3dhcy8gZXhwZWN0aW5nIGEgc2VyaWVzIG9m
ICJjb252ZXJ0IFhYWFhYIGFuZCBhbGwgY2FsbGVycy91c2VycyIKcGF0Y2hlcyBmb2xsb3dlZCBi
eSBhIHRyaXZpYWwgb25lIHRvIHN3aXRjaCB0aGUgZGVmaW5pdGlvbiwgbm90IGEgZ2lhbnQKcGls
ZSBvZiBjaGFuZ2UuICBGV0lXIEkgZG9uJ3QgbWluZCBzbyBtdWNoIGlmIHlvdSBtYWtlIGEgcGF0
Y2gKY29udGFpbmluZyBhIGNoYW5nZSBmb3Igc29tZSBzdXBlci1jb21tb24gcHJpbWl0aXZlIGFu
ZCBhIGhvamlsbGlvbgpsaXR0bGUgZGlmZiBodW5rcyB0cmVlLXdpZGUsIGJ1dCBvbmx5IG9uZSBs
b2dpY2FsIGNoYW5nZSBhdCBhIHRpbWUgZm9yIGEKYmlnIHBhdGNoLCBwbGVhc2UuLi4KCkkgcXVp
dGUgcHJlZmVyIHNlZWluZyB0aGUgd2hvbGUgc2VyaWVzIGZyb20gc3RhcnQgdG8gZmluaXNoIGFs
bCBwYWNrYWdlZAp1cCBpbiBvbmUgc2VyaWVzLCBidXQgd293IHRoaXMgd2FzIG92ZXJ3aGVsbWlu
Zy4gOi8KCi0tRAoKPFVMVFJBU05JUD4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mu
b3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczIt
ZGV2ZWw=
