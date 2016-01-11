From: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: RE: ext4 out of order when use cfq scheduler
Date: Mon, 11 Jan 2016 09:05:20 +0000
Message-ID: <97be88d3acae4317ba1b6443f859ada0@SGPMBX1004.APAC.bosch.com>
References: <697280a570654ae0aa1723fb7d11f51e@SGPMBX1004.APAC.bosch.com>
 <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_97be88d3acae4317ba1b6443f859ada0SGPMBX1004APACboschcom_"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:63013 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084AbcAKJFb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jan 2016 04:05:31 -0500
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--_002_97be88d3acae4317ba1b6443f859ada0SGPMBX1004APACboschcom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


> -----Original Message-----
> From: HUANG Weller (CM/ESW12-CN)
> Sent: Friday, January 08, 2016 8:47 AM
> To: 'Jan Kara' <jack@suse.cz>
> Cc: linux-ext4@vger.kernel.org; Li, Michael <huayil@qti.qualcomm.com>
> Subject: RE: ext4 out of order when use cfq scheduler
>=20
> > >
> > > >
> > > > OK, so I was looking into the code and indeed, reality is correct
> > > > and my mental model was wrong! ;) I thought that inode gets added
> > > > to the list of inodes for which we need to wait for data IO
> > > > completion during transaction commit during block allocation. And I=
 was
> wrong.
> > > > It used to happen in
> > > > mpage_da_map_and_submit() until commit f3b59291a69d (ext4: remove
> > > > calls to
> > > > ext4_jbd2_file_inode() from delalloc write path) where it got
> > > > removed. And that was wrong because although we submit data writes
> > > > before dropping handle for allocating transaction and updating
> > > > i_size, nobody guarantees that data IO is not delayed in the block
> > > > layer until
> > transaction commit.
> > > > Which seems to happen in your case. I'll send a fix. Thanks for
> > > > your report and persistence!
> > > >
> > >
> > > Thanks a lot for your feedback :-)
> > > Because I am not familiar with the detail of the ext4 internal code.
> > > I will try to
> > understand your explanation which you describe above.  And have a look
> > on related funcations.
> > > Could you send the fix in this mail ?
> > > And whether the kernel 3.14 also have such issue, right ?
> >
> > The problem is in all kernels starting with 3.8. Attached is a patch
> > which should fix the issue. Can you test whether it fixes the problem f=
or you?
> >
> > 								Honza
> > --
>=20
> Yes, of course I will redo the test with the patch. And also give you fee=
dback.

Test result:
Test on 2 targets with the kernel applied your patch. Both of them are OK a=
fter 5000 power failure tests. Our target test cycle is 10,000.
By the way, since your original patch can't be applied on 3.x kernel, The a=
ttached one  is based on yours and can applied on old kernel(mine is 3.10) =
directly.

>=20
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR

--_002_97be88d3acae4317ba1b6443f859ada0SGPMBX1004APACboschcom_
Content-Type: application/octet-stream;
	name="0001-ext4-Fix-data-exposure-after-a-crash.patch"
Content-Description: 0001-ext4-Fix-data-exposure-after-a-crash.patch
Content-Disposition: attachment;
	filename="0001-ext4-Fix-data-exposure-after-a-crash.patch"; size=3185;
	creation-date="Mon, 11 Jan 2016 09:05:11 GMT";
	modification-date="Mon, 11 Jan 2016 09:04:50 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5OGNmODIxZTI3MDc0ODQ4NjEzMjA3OWFjOGQxYzk1NTdjOWFkZmI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYW4gS2FyYSA8amFja0BzdXNlLmN6PgpEYXRlOiBUaHUsIDcg
SmFuIDIwMTYgMTI6MjE6MjUgKzAxMDAKU3ViamVjdDogW1BBVENIXSBleHQ0OiBGaXggZGF0YSBl
eHBvc3VyZSBhZnRlciBhIGNyYXNoCgpIdWFuZyBoYXMgcmVwb3J0ZWQgdGhhdCBpbiBoaXMgcG93
ZXJmYWlsIHRlc3RpbmcgaGUgaXMgc2VlaW5nIHN0YWxlCmJsb2NrIGNvbnRlbnRzIGluIHNvbWUg
b2YgcmVjZW50bHkgYWxsb2NhdGVkIGJsb2NrcyBhbHRob3VnaCBoZSBtb3VudHMKZXh0NCBpbiBk
YXRhPW9yZGVyZWQgbW9kZS4gQWZ0ZXIgc29tZSBpbnZlc3RpZ2F0aW9uIEkgaGF2ZSBmb3VuZCBv
dXQKdGhhdCBpbmRlZWQgd2hlbiBkZWxheWVkIGFsbG9jYXRpb24gaXMgdXNlZCwgd2UgZG9uJ3Qg
YWRkIGlub2RlIHRvCnRyYW5zYWN0aW9uJ3MgbGlzdCBvZiBpbm9kZXMgbmVlZGluZyBmbHVzaGlu
ZyBiZWZvcmUgY29tbWl0LiBPcmlnaW5hbGx5CndlIHdlcmUgZG9pbmcgdGhhdCBidXQgY29tbWl0
IGYzYjU5MjkxYTY5ZCByZW1vdmVkIHRoZSBsb2dpYyB3aXRoIGEKZmxhd2VkIGFyZ3VtZW50IHRo
YXQgaXQgaXMgbm90IG5lZWRlZC4KClRoZSBwcm9ibGVtIGlzIHRoYXQgYWx0aG91Z2ggZm9yIGRl
bGF5ZWQgYWxsb2NhdGVkIGJsb2NrcyB3ZSB3cml0ZSB0aGVpcgpjb250ZW50cyBpbW1lZGlhdGVs
eSBhZnRlciBhbGxvY2F0aW5nIHRoZW0sIHRoZXJlIGlzIG5vIGd1YXJhbnRlZSB0aGF0CnRoZSBJ
TyBzY2hlZHVsZXIgb3IgZGV2aWNlIGRvZXNuJ3QgcmVvcmRlciB0aGluZ3MgYW5kIHRodXMgdHJh
bnNhY3Rpb24KYWxsb2NhdGluZyBibG9ja3MgYW5kIGF0dGFjaGluZyB0aGVtIHRvIGlub2RlIGNh
biByZWFjaCBzdGFibGUgc3RvcmFnZQpiZWZvcmUgYWN0dWFsIGJsb2NrIGNvbnRlbnRzLiBBY3R1
YWxseSB3aGVuZXZlciB3ZSBhdHRhY2ggZnJlc2hseQphbGxvY2F0ZWQgYmxvY2tzIHRvIGlub2Rl
IHVzaW5nIGEgd3JpdHRlbiBleHRlbnQsIHdlIHNob3VsZCBhZGQgaW5vZGUgdG8KdHJhbnNhY3Rp
b24ncyBvcmRlcmVkIGlub2RlIGxpc3QgdG8gbWFrZSBzdXJlIHdlIHByb3Blcmx5IHdhaXQgZm9y
IGJsb2NrCmNvbnRlbnRzIHRvIGJlIHdyaXR0ZW4gYmVmb3JlIGNvbW1pdHRpbmcgdGhlIHRyYW5z
YWN0aW9uLiBTbyB0aGF0IGlzCndoYXQgd2UgZG8gaW4gdGhpcyBwYXRjaC4gVGhpcyBhbHNvIGhh
bmRsZXMgb3RoZXIgY2FzZXMgd2hlcmUgc3RhbGUgZGF0YQpleHBvc3VyZSB3YXMgcG9zc2libGUg
LSBsaWtlIGZpbGxpbmcgaG9sZSB2aWEgbW1hcCBpbgpkYXRhPW9yZGVyZWQsbm9kZWxhbGxvYyBt
b2RlLgoKVGhlIG9ubHkgZXhjZXB0aW9uIHRvIHRoZSBhYm92ZSBydWxlIGFyZSBleHRlbmRpbmcg
ZGlyZWN0IElPIHdyaXRlcyB3aGVyZQpibGtkZXZfZGlyZWN0X0lPKCkgd2FpdHMgZm9yIElPIHRv
IGNvbXBsZXRlIGJlZm9yZSBpbmNyZWFzaW5nIGlfc2l6ZSBhbmQKdGh1cyBzdGFsZSBkYXRhIGV4
cG9zdXJlIGlzIG5vdCBwb3NzaWJsZS4gRm9yIG5vdyB3ZSBkb24ndCBjb21wbGljYXRlCnRoZSBj
b2RlIHdpdGggb3B0aW1pemluZyB0aGlzIHNwZWNpYWwgY2FzZSBzaW5jZSB0aGUgb3ZlcmhlYWQg
aXMgcHJldHR5Cmxvdy4gSW4gY2FzZSB0aGlzIGlzIG9ic2VydmVkIHRvIGJlIGEgcGVyZm9ybWFu
Y2UgcHJvYmxlbSB3ZSBjYW4gYWx3YXlzCmhhbmRsZSBpdCB1c2luZyBhIHNwZWNpYWwgZmxhZyB0
byBleHQ0X21hcF9ibG9ja3MoKS4KCkNDOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCkZpeGVzOiBm
M2I1OTI5MWE2OWQwYjczNGJlMWZjOGJlNDg5ZmVmMmRkODQ2ZDNkClJlcG9ydGVkLWJ5OiAiSFVB
TkcgV2VsbGVyIChDTS9FU1cxMi1DTikiIDxXZWxsZXIuSHVhbmdAY24uYm9zY2guY29tPgpTaWdu
ZWQtb2ZmLWJ5OiBKYW4gS2FyYSA8amFja0BzdXNlLmN6PgpmaXggY29uZmxpY3Qgd2l0aCAzLjEw
IGtlcm5lbC4KU2lnbmVkLW9mZi1ieTogd2VsbGVyIGh1YW5nIDx3ZWxsZXIuaHVhbmdAY24uYm9z
Y2guY29tPgotLS0KIGZzL2V4dDQvaW5vZGUuYyB8ICAgMjAgKysrKysrKysrKystLS0tLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2V4dDQvaW5vZGUuYyBiL2ZzL2V4dDQvaW5vZGUuYwppbmRleCBlNDhiZDVhLi5k
NWQ2ZDZjIDEwMDY0NAotLS0gYS9mcy9leHQ0L2lub2RlLmMKKysrIGIvZnMvZXh0NC9pbm9kZS5j
CkBAIC03NTEsNiArNzUxLDE3IEBAIGhhc196ZXJvb3V0OgogCQlpbnQgcmV0ID0gY2hlY2tfYmxv
Y2tfdmFsaWRpdHkoaW5vZGUsIG1hcCk7CiAJCWlmIChyZXQgIT0gMCkKIAkJCXJldHVybiByZXQ7
CisKKwkJLyoKKwkJICogSW5vZGVzIHdpdGggZnJlc2hseSBhbGxvY2F0ZWQgYmxvY2tzIHdoZXJl
IGNvbnRlbnRzIHdpbGwgYmUKKwkJICogdmlzaWJsZSBhZnRlciB0cmFuc2FjdGlvbiBjb21taXQg
bXVzdCBiZSBvbiB0cmFuc2FjdGlvbidzCisJCSAqIG9yZGVyZWQgZGF0YSBsaXN0LgorCQkgKi8K
KwkJaWYoZXh0NF9zaG91bGRfb3JkZXJfZGF0YShpbm9kZSkpIHsKKwkJCXJldCA9IGV4dDRfamJk
Ml9maWxlX2lub2RlKGhhbmRsZSwgaW5vZGUpOworCQkJaWYgKHJldCkKKwkJCQlyZXR1cm4gcmV0
OworCQl9CiAJfQogCXJldHVybiByZXR2YWw7CiB9CkBAIC0xMTEwLDE1ICsxMTIxLDYgQEAgc3Rh
dGljIGludCBleHQ0X3dyaXRlX2VuZChzdHJ1Y3QgZmlsZSAqZmlsZSwKIAlpbnQgaV9zaXplX2No
YW5nZWQgPSAwOwogCiAJdHJhY2VfZXh0NF93cml0ZV9lbmQoaW5vZGUsIHBvcywgbGVuLCBjb3Bp
ZWQpOwotCWlmIChleHQ0X3Rlc3RfaW5vZGVfc3RhdGUoaW5vZGUsIEVYVDRfU1RBVEVfT1JERVJF
RF9NT0RFKSkgewotCQlyZXQgPSBleHQ0X2piZDJfZmlsZV9pbm9kZShoYW5kbGUsIGlub2RlKTsK
LQkJaWYgKHJldCkgewotCQkJdW5sb2NrX3BhZ2UocGFnZSk7Ci0JCQlwYWdlX2NhY2hlX3JlbGVh
c2UocGFnZSk7Ci0JCQlnb3RvIGVycm91dDsKLQkJfQotCX0KLQogCWlmIChleHQ0X2hhc19pbmxp
bmVfZGF0YShpbm9kZSkpIHsKIAkJcmV0ID0gZXh0NF93cml0ZV9pbmxpbmVfZGF0YV9lbmQoaW5v
ZGUsIHBvcywgbGVuLAogCQkJCQkJIGNvcGllZCwgcGFnZSk7Ci0tIAoxLjcuOS41Cgo=

--_002_97be88d3acae4317ba1b6443f859ada0SGPMBX1004APACboschcom_--

