From: George Barnett <gbarnett@atlassian.com>
Subject: Re: [PATCH] ext4/jbd2: don't wait (forever) for stale tid
 caused by wraparound
Date: Mon, 18 Mar 2013 15:24:49 +1100
Message-ID: <91B5F5AF93734BAA86939ED896DDEF63@atlassian.com>
References: <B2EC601CDDA242189A46599B31EA6AD3@atlassian.com>
 <1363412062.3937.196.camel@deadeye.wl.decadent.org.uk>
 <20130318025401.GA12611@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="51469711_47195e5_153bc"
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-ext4@vger.kernel.org,
 Debian kernel maintainers <debian-kernel@lists.debian.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
In-Reply-To: <20130318025401.GA12611@thunk.org>
Resent-Message-ID: <S0CgDKpSzTJ.A.jIH.tcpRRB@bendel>
List-URL: <http://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

--51469711_47195e5_153bc
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, 18 March 2013 at 1:54 PM, Theodore Ts'o wrote:
> Thanks for reporting this. I thought we had fixed this in 3.0.
> Before then, when we had a tid wrap, it would result in kjournald
> spinning forever. I suspect this was your "spontaneous reboots" that
> you mentioned you mentioned when you were using 2.6.39 --- did you
> have a hardware or softward watchdog timer enabled by any chance?
> 
> 

Thank you for your prompt attention on this.  It's greatly appreciated!

We believe our previous spontaneous reboots were caused by https://bugzilla.kernel.org/show_bug.cgi?id=16991 which was resolved by our move to a 3.2 kernel (we were on a 2.6.38-bpo kernel ^1).  We do not presently use any watchdogs.
> Since we didn't have a good way of reproducing the problem at the
> time, I didn't realize that the problem had not been fully fixed;
> since while jbd2_log_start_commit() would no longer cause kjournald to
> spin forwever, a subsequent call to jbd2_log_wait_commit() with a
> stale transaction id would wait for a very long time (possibly until
> the heat death of the universe :-)
> 
> 

This would mirror what we've seen, although our ops guys haven't been waiting around for any universes to die :)
> I think a patch like this should fix things; I've run a stress test
> with a hack to increment the transaction id by 1 << 24 after each
> commit, to more quickly cause an tid wrap, and the regression tests
> seem to be passing without complaint.
> 
> 

Excellent news.  Again, thank you for your help in this regard.

@Ben - could you let me know what your preferred course of action would be here?  As I'm sure you can understand, I do not wish to maintain a forked kernel from Debian upstream.  Is this something you would be prepared to integrate into the 3.2 BPO kernels?

Best regards,

George

1. We moved to 2.6.38 in order to get access to the packet steering patches which were put into the kernel in ~.33 or .34 from memory.  This gave us quite a nice performance bump to our storage speed and hence we didn't want to lose it by going back to .32 to get the 200d uptime bug fix.
--51469711_47195e5_153bc
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


                <div><span style=3D=22color: rgb(160, 160, 168); =22>On M=
onday, 18 March 2013 at 1:54 PM, Theodore Ts'o wrote:</span></div><blockq=
uote type=3D=22cite=22 style=3D=22border-left-style:solid;border-width:1p=
x;margin-left:0px;padding-left:10px;=22>
                    <span><div><div><div>Thanks for reporting this.  I th=
ought we had fixed this in 3.0.</div><div>Before then, when we had a tid =
wrap, it would result in kjournald</div><div>spinning forever.  I suspect=
 this was your =22spontaneous reboots=22 that</div><div>you mentioned you=
 mentioned when you were using 2.6.39 --- did you</div><div>have a hardwa=
re or softward watchdog timer enabled by any chance=3F</div></div></div><=
/span></blockquote><div>Thank you for your prompt attention on this. &nbs=
p;It's greatly appreciated=21</div><div><br></div><div>We believe our pre=
vious spontaneous reboots were caused by&nbsp;https://bugzilla.kernel.org=
/show=5Fbug.cgi=3Fid=3D16991 which was resolved by our move to a 3.2 kern=
el (we were on a 2.6.38-bpo kernel =5E1). &nbsp;We do not presently use a=
ny watchdogs.</div><blockquote type=3D=22cite=22 style=3D=22border-left-s=
tyle:solid;border-width:1px;margin-left:0px;padding-left:10px;=22><span><=
div><div><div>Since we didn't have a good way of reproducing the problem =
at the</div><div>time, I didn't realize that the problem had not been ful=
ly fixed;</div><div>since while jbd2=5Flog=5Fstart=5Fcommit() would no lo=
nger cause kjournald to</div><div>spin forwever, a subsequent call to jbd=
2=5Flog=5Fwait=5Fcommit() with a</div><div>stale transaction id would wai=
t for a very long time (possibly until</div><div>the heat death of the un=
iverse :-)</div></div></div></span></blockquote><div>This would mirror wh=
at we've seen, although our ops guys haven't been waiting around for any =
universes to die :)</div><blockquote type=3D=22cite=22 style=3D=22border-=
left-style:solid;border-width:1px;margin-left:0px;padding-left:10px;=22><=
span><div><div><div>I think a patch like this should fix things; I've run=
 a stress test</div><div>with a hack to increment the transaction id by 1=
 &lt;&lt; 24 after each</div><div>commit, to more quickly cause an tid wr=
ap, and the regression tests</div><div>seem to be passing without complai=
nt.</div></div></div></span></blockquote><div>Excellent news. &nbsp;Again=
, thank you for your help in this regard.</div><div><br></div><div>=40Ben=
 - could you let me know what your preferred course of action would be he=
re=3F &nbsp;As I'm sure you can understand, I do not wish to maintain a f=
orked kernel from Debian upstream. &nbsp;Is this something you would be p=
repared to integrate into the 3.2 BPO kernels=3F</div><div><br></div><div=
>Best regards,</div><div><br></div><div>George</div><div><br></div><div>1=
. We moved to 2.6.38 in order to get access to the packet steering patche=
s which were put into the kernel in =7E.33 or .34 from memory. &nbsp;This=
 gave us quite a nice performance bump to our storage speed and hence we =
didn't want to lose it by going back to .32 to get the 200d uptime bug fi=
x.</div>
            
--51469711_47195e5_153bc--
