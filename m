From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] direct-io: Implement generic deferred AIO completions
Date: Thu, 1 Aug 2013 10:17:20 +0200
Message-ID: <20130801081720.GA29497@lst.de>
References: <1373493739-2243-1-git-send-email-jack@suse.cz>
	<20130712004421.GE3438@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, hch@infradead.org,
	Jeff Moyer <jmoyer@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130712004421.GE3438@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

T24gRnJpLCBKdWwgMTIsIDIwMTMgYXQgMTA6NDQ6MjFBTSArMTAwMCwgRGF2ZSBDaGlubmVyIHdy
b3RlOgo+IE9uIFRodSwgSnVsIDExLCAyMDEzIGF0IDEyOjAyOjE4QU0gKzAyMDAsIEphbiBLYXJh
IHdyb3RlOgo+ID4gRnJvbTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBpbmZyYWRlYWQub3JnPgo+
ID4gCj4gPiBBZGQgc3VwcG9ydCB0byB0aGUgY29yZSBkaXJlY3QtaW8gY29kZSB0byBkZWZlciBB
SU8gY29tcGxldGlvbnMgdG8gdXNlcgo+ID4gY29udGV4dCB1c2luZyBhIHdvcmtxdWV1ZS4gIFRo
aXMgcmVwbGFjZXMgb3BlbmNvZGVkIGFuZCBsZXNzIGVmZmljaWVudAo+ID4gY29kZSBpbiBYRlMg
YW5kIGV4dDQgYW5kIHdpbGwgYmUgbmVlZGVkIHRvIHByb3Blcmx5IHN1cHBvcnQgT18oRClTWU5D
Cj4gPiBmb3IgQUlPLgo+IAo+IEkgZG9uJ3Qgc2VlIGhvdyB0aGlzIGlzIGFueSBtb3JlIGVmZmlj
aWVudCB0aGFuIHRoZSBkZWZlcnJhbAo+IHRoYXQgWEZTIGFscmVhZHkgZG9lcyBmb3IgZGlyZWN0
IElPIGNvbXBsZXRpb24gLSBpdCBqdXN0IGNoYW5nZXMKPiB3aGF0IHF1ZXVlcyBJTyBmb3IgY29t
cGxldGlvbnMuIEFuZCBvbiB0aGF0IHRvcGljOgoKSXQgYXZvaWRlZCBhIG1lbW9yeSBhbGxvY2F0
aW9uIGZvciBlYWNoIGTRlnJlY3QgSS9PIHdyaXRlLgoKPiBGV0lXLCBpbiBYRlMgd2UgcXVldWUg
dW53cml0dGVuIGV4dGVudCBjb252ZXJzaW9uIGNvbXBsZXRpb25zIG9uIGEKPiBkaWZmZXJlbnQg
d29ya3F1ZXVlIHRvIEVPRiBzaXplIHVwZGF0ZSBjb21wbGV0aW9ucyBiZWNhdXNlIHRoZQo+IGxh
dHRlciBhcmUgc21hbGwsIGZhc3QgYW5kIHJhcmVseSByZXF1aXJlIElPIG9yIGdldCBibG9ja2Vk
LiBUaGUKPiBkYXRhIElPIGNvbXBsZXRpb24gd29ya3F1ZXVlIGZvciBFT0YgdXBkYXRlcyBoYXMg
dGhlIHNhbWUKPiBjb25jdXJyZW5jeSBhbmQgZGVwdGggYXMgdGhlIHVud3JpdHRlbiBleHRlbnQg
d29yayBxdWV1ZSAoaS5lLiAyNTYKPiB3b3JrZXJzIHBlciBjcHUgcGVyIHN1cGVyYmxvY2spLiBT
byBwdXNoaW5nIGFsbCBvZiB0aGlzIERJTyBhbmQgRU9GCj4gY29tcGxldGlvbiB3b3JrIGludG8g
YSBzaW5nbGUgdGhyZWFkZWQgZ2xvYmFsIHdvcmtxdWV1ZSB0aGF0IGNhbgo+IGJsb2NrIGluIGV2
ZXJ5IElPIGNvbXBsZXRpb24gZG9lc24ndCBzZWVtIGxpa2UgYSB2ZXJ5IHNtYXJ0IGlkZWEgdG8K
PiBtZS4uLgoKQ3VycmVudGx5IHRoZSBkaXJlY3QgSS9PIGNvZGUgZG9lc24ndCBzdXBwb3J0IGFz
eW5jIGV4dGVuZGluZyB3cml0ZXMuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3Nz
LnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
