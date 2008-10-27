From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: why unlikely(rsv) in ext3_clear_inode()?
Date: Mon, 27 Oct 2008 19:32:11 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2118266723-1225149815=:19731"
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48120 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYJ0XcW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 19:32:22 -0400
In-Reply-To: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
Content-ID: <alpine.DEB.1.10.0810271929060.20039@gandalf.stny.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2118266723-1225149815=:19731
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.1.10.0810271929061.20039@gandalf.stny.rr.com>


On Mon, 27 Oct 2008, Mike Snitzer wrote:

> Please see: e6022603b9aa7d61d20b392e69edcdbbc1789969
> 
> Having a look at the LKML archives this was raised back in 2006:
> http://lkml.org/lkml/2006/6/23/337
> 
> I'm not interested in whether unlikely() actually helps here.
> 
> I'm still missing _why_ rsv is mostly NULL at this callsite, as Andrew
> asserted here:
> http://lkml.org/lkml/2006/6/23/400
> 
> And then Steve here: http://lkml.org/lkml/2006/6/24/76
> Where he said:
> "The problem is that in these cases the pointer is NULL several thousands
> of times for every time it is not NULL (if ever).  The non-NULL case is
> where an error occurred or something very special.  So I don't see how
> the if here is a problem?"
> 
> I'm missing which error or what "something very special" is the
> unlikely() reason for having rsv be NULL.
> 
> Looking at the code; ext3_clear_inode() is _the_ place where the
> i_block_alloc_info is cleaned up.  In my testing the rsv is _never_
> NULL if the file was open for writing.  Are we saying that reads are
> much more common than writes?  May be a reasonable assumption but
> saying as much is very different than what Steve seemed to be eluding
> to...
> 
> Anyway, I'd appreciate some clarification here.

Attached is a patch that I used for counting.

Here's my results:
# cat /debug/tracing/ftrace_null 
45
# cat /debug/tracing/ftrace_nonnull 
7

Ah, seems that there is cases where it is nonnull more often. Anyway, it 
obviously is not a fast path (total of 52). Even if it was all null, it is 
not big enough to call for the confusion.

I'd suggest removing the if conditional, and just calling kfree.

-- Steve

--8323328-2118266723-1225149815=:19731
Content-Type: TEXT/x-diff; name=trace-ext3-null.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.1.10.0810271932110.20039@gandalf.stny.rr.com>
Content-Description: 
Content-Disposition: attachment; filename=trace-ext3-null.patch

LS0tDQogZnMvZXh0My9zdXBlci5jICAgICAgICAgICB8ICAgIDggKysrKw0K
IGtlcm5lbC90cmFjZS9NYWtlZmlsZSAgICAgfCAgICAxIA0KIGtlcm5lbC90
cmFjZS90cmFjZV9udWxsLmMgfCAgIDc2ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysNCiAzIGZpbGVzIGNoYW5nZWQs
IDg0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KSW5kZXg6IGxp
bnV4LXRpcC5naXQvZnMvZXh0My9zdXBlci5jDQo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09DQotLS0gbGludXgtdGlwLmdpdC5vcmlnL2ZzL2V4dDMvc3VwZXIu
YwkyMDA4LTEwLTI0IDEwOjA4OjQzLjAwMDAwMDAwMCAtMDQwMA0KKysrIGxp
bnV4LXRpcC5naXQvZnMvZXh0My9zdXBlci5jCTIwMDgtMTAtMjcgMTk6MDE6
MjIuMDAwMDAwMDAwIC0wNDAwDQpAQCAtNTAyLDYgKzUwMiw5IEBAIHN0YXRp
YyB2b2lkIGRlc3Ryb3lfaW5vZGVjYWNoZSh2b2lkKQ0KIAlrbWVtX2NhY2hl
X2Rlc3Ryb3koZXh0M19pbm9kZV9jYWNoZXApOw0KIH0NCiANCitleHRlcm4g
dm9pZCBmdHJhY2VfbnVsbCh2b2lkKTsNCitleHRlcm4gdm9pZCBmdHJhY2Vf
bm9ubnVsbCh2b2lkKTsNCisNCiBzdGF0aWMgdm9pZCBleHQzX2NsZWFyX2lu
b2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUpDQogew0KIAlzdHJ1Y3QgZXh0M19i
bG9ja19hbGxvY19pbmZvICpyc3YgPSBFWFQzX0koaW5vZGUpLT5pX2Jsb2Nr
X2FsbG9jX2luZm87DQpAQCAtNTE5LDggKzUyMiwxMSBAQCBzdGF0aWMgdm9p
ZCBleHQzX2NsZWFyX2lub2RlKHN0cnVjdCBpbm9kDQogI2VuZGlmDQogCWV4
dDNfZGlzY2FyZF9yZXNlcnZhdGlvbihpbm9kZSk7DQogCUVYVDNfSShpbm9k
ZSktPmlfYmxvY2tfYWxsb2NfaW5mbyA9IE5VTEw7DQotCWlmICh1bmxpa2Vs
eShyc3YpKQ0KKwlpZiAodW5saWtlbHkocnN2KSkgew0KKwkJZnRyYWNlX25v
bm51bGwoKTsNCiAJCWtmcmVlKHJzdik7DQorCX0gZWxzZQ0KKwkJZnRyYWNl
X251bGwoKTsNCiB9DQogDQogc3RhdGljIGlubGluZSB2b2lkIGV4dDNfc2hv
d19xdW90YV9vcHRpb25zKHN0cnVjdCBzZXFfZmlsZSAqc2VxLCBzdHJ1Y3Qg
c3VwZXJfYmxvY2sgKnNiKQ0KSW5kZXg6IGxpbnV4LXRpcC5naXQva2VybmVs
L3RyYWNlL01ha2VmaWxlDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0g
bGludXgtdGlwLmdpdC5vcmlnL2tlcm5lbC90cmFjZS9NYWtlZmlsZQkyMDA4
LTEwLTI3IDE5OjAwOjAzLjAwMDAwMDAwMCAtMDQwMA0KKysrIGxpbnV4LXRp
cC5naXQva2VybmVsL3RyYWNlL01ha2VmaWxlCTIwMDgtMTAtMjcgMTk6MDg6
MjUuMDAwMDAwMDAwIC0wNDAwDQpAQCAtMTMsNiArMTMsNyBAQCBlbmRpZg0K
IG9iai0kKENPTkZJR19GVU5DVElPTl9UUkFDRVIpICs9IGxpYmZ0cmFjZS5v
DQogb2JqLSQoQ09ORklHX1JJTkdfQlVGRkVSKSArPSByaW5nX2J1ZmZlci5v
DQogDQorb2JqLSQoQ09ORklHX1RSQUNJTkcpICs9IHRyYWNlX251bGwubw0K
IG9iai0kKENPTkZJR19UUkFDSU5HKSArPSB0cmFjZS5vDQogb2JqLSQoQ09O
RklHX0NPTlRFWFRfU1dJVENIX1RSQUNFUikgKz0gdHJhY2Vfc2NoZWRfc3dp
dGNoLm8NCiBvYmotJChDT05GSUdfU1lTUFJPRl9UUkFDRVIpICs9IHRyYWNl
X3N5c3Byb2Yubw0KSW5kZXg6IGxpbnV4LXRpcC5naXQva2VybmVsL3RyYWNl
L3RyYWNlX251bGwuYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIC9k
ZXYvbnVsbAkxOTcwLTAxLTAxIDAwOjAwOjAwLjAwMDAwMDAwMCArMDAwMA0K
KysrIGxpbnV4LXRpcC5naXQva2VybmVsL3RyYWNlL3RyYWNlX251bGwuYwky
MDA4LTEwLTI3IDE5OjIzOjE1LjAwMDAwMDAwMCAtMDQwMA0KQEAgLTAsMCAr
MSw3NiBAQA0KKy8qDQorICogRnVuY3Rpb24gcHJvZmlsZXINCisgKg0KKyAq
IENvcHlyaWdodCAoQykgMjAwOCBTdGV2ZW4gUm9zdGVkdCA8c3Jvc3RlZHRA
cmVkaGF0LmNvbT4NCisgKi8NCisjaW5jbHVkZSA8bGludXgva2FsbHN5bXMu
aD4NCisjaW5jbHVkZSA8bGludXgvc2VxX2ZpbGUuaD4NCisjaW5jbHVkZSA8
bGludXgvc3BpbmxvY2suaD4NCisjaW5jbHVkZSA8bGludXgvZGVidWdmcy5o
Pg0KKyNpbmNsdWRlIDxsaW51eC91YWNjZXNzLmg+DQorI2luY2x1ZGUgPGxp
bnV4L21vZHVsZS5oPg0KKyNpbmNsdWRlIDxsaW51eC9mdHJhY2UuaD4NCisj
aW5jbHVkZSA8bGludXgvaGFzaC5oPg0KKyNpbmNsdWRlIDxsaW51eC9mcy5o
Pg0KKyNpbmNsdWRlIDxhc20vbG9jYWwuaD4NCisjaW5jbHVkZSAidHJhY2Uu
aCINCisNCisNCitzdGF0aWMgYXRvbWljX3QgZnRyYWNlX251bGxfY291bnQ7
DQorc3RhdGljIGF0b21pY190IGZ0cmFjZV9ub25udWxsX2NvdW50Ow0KKw0K
K3ZvaWQgZnRyYWNlX251bGwodm9pZCkNCit7DQorCWF0b21pY19pbmMoJmZ0
cmFjZV9udWxsX2NvdW50KTsNCit9DQorRVhQT1JUX1NZTUJPTChmdHJhY2Vf
bnVsbCk7DQorDQordm9pZCBmdHJhY2Vfbm9ubnVsbCh2b2lkKQ0KK3sNCisJ
YXRvbWljX2luYygmZnRyYWNlX25vbm51bGxfY291bnQpOw0KK30NCitFWFBP
UlRfU1lNQk9MKGZ0cmFjZV9ub25udWxsKTsNCisNCitzdGF0aWMgc3NpemVf
dA0KK3RyYWNpbmdfcmVhZF9sb25nKHN0cnVjdCBmaWxlICpmaWxwLCBjaGFy
IF9fdXNlciAqdWJ1ZiwNCisJCSAgc2l6ZV90IGNudCwgbG9mZl90ICpwcG9z
KQ0KK3sNCisJYXRvbWljX3QgKnAgPSBmaWxwLT5wcml2YXRlX2RhdGE7DQor
CWNoYXIgYnVmWzY0XTsNCisJaW50IHI7DQorDQorCXIgPSBzcHJpbnRmKGJ1
ZiwgIiVkXG4iLCBhdG9taWNfcmVhZChwKSk7DQorDQorCXJldHVybiBzaW1w
bGVfcmVhZF9mcm9tX2J1ZmZlcih1YnVmLCBjbnQsIHBwb3MsIGJ1Ziwgcik7
DQorfQ0KKw0KK3N0YXRpYyBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHRyYWNp
bmdfcmVhZF9sb25nX2ZvcHMgPSB7DQorCS5vcGVuCQk9IHRyYWNpbmdfb3Bl
bl9nZW5lcmljLA0KKwkucmVhZAkJPSB0cmFjaW5nX3JlYWRfbG9uZywNCit9
Ow0KKw0KKw0KK3N0YXRpYyBfX2luaXQgaW50IGZ0cmFjZV9udWxsX2luaXQo
dm9pZCkNCit7DQorCXN0cnVjdCBkZW50cnkgKmRfdHJhY2VyOw0KKwlzdHJ1
Y3QgZGVudHJ5ICplbnRyeTsNCisNCisJZF90cmFjZXIgPSB0cmFjaW5nX2lu
aXRfZGVudHJ5KCk7DQorDQorCWVudHJ5ID0gZGVidWdmc19jcmVhdGVfZmls
ZSgiZnRyYWNlX251bGwiLCAwNDQ0LCBkX3RyYWNlciwNCisJCQkJICAgICZm
dHJhY2VfbnVsbF9jb3VudCwNCisJCQkJICAgICZ0cmFjaW5nX3JlYWRfbG9u
Z19mb3BzKTsNCisJaWYgKCFlbnRyeSkNCisJCXByX3dhcm5pbmcoIkNvdWxk
IG5vdCBjcmVhdGUgZGVidWdmcyAnZnRyYWNlX251bGwnIGVudHJ5XG4iKTsN
CisNCisJZW50cnkgPSBkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJmdHJhY2Vfbm9u
bnVsbCIsIDA0NDQsIGRfdHJhY2VyLA0KKwkJCQkgICAgJmZ0cmFjZV9ub25u
dWxsX2NvdW50LA0KKwkJCQkgICAgJnRyYWNpbmdfcmVhZF9sb25nX2ZvcHMp
Ow0KKwlpZiAoIWVudHJ5KQ0KKwkJcHJfd2FybmluZygiQ291bGQgbm90IGNy
ZWF0ZSBkZWJ1Z2ZzICdmdHJhY2Vfbm9ubnVsbCcgZW50cnlcbiIpOw0KKw0K
Kw0KKwlyZXR1cm4gMDsNCit9DQorDQorZGV2aWNlX2luaXRjYWxsKGZ0cmFj
ZV9udWxsX2luaXQpOw0K

--8323328-2118266723-1225149815=:19731--
