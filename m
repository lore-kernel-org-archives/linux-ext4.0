From: Quentin Godfroy <godfroy@clipper.ens.fr>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Sun, 5 Oct 2008 11:15:26 +0200
Message-ID: <20081005091526.GA678@goelette.ens.fr>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rJwd6BRFiFCcLxzm"
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nef2.ens.fr ([129.199.96.40]:2401 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYJEJPj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Oct 2008 05:15:39 -0400
Content-Disposition: inline
In-Reply-To: <20081003003548.GA18138@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 02, 2008 at 08:35:48PM -0400, Theodore Tso wrote:
> On Wed, Oct 01, 2008 at 12:23:58AM +0200, Quentin wrote:
> > 
> > Of course. However since I unmounted and remounted /home the 'buffer' line
> > is now only 59megs, and they are still not dropped when a program tries to
> > malloc all the memory. I'll tell next time the problem shows up (it
> > can take ten days)
> > 
> 
> Are you willing to patch and recompile your kernel?  If so, the
> following patch would be very helpful in determining what is going on.
> It allows us to see what buffer heads are in use for a particular
> block device.  Attached please the kernel patch and the user program.

Now that the machine is again in the 100M+ in buffers (still unreleased when
a program asks for all the memory), I launched the program on the devices
which support / and /home.

I also attached /proc/meminfo and /proc/slabinfo

In both cases it freezes solid the machine for more than a minute or so, and
it overflows the dmesg with messages. Here is shown what I got

[166632.382632] buffer dirty: block 35491 count 1
[166632.386827] buffer dirty: block 35493 count 3
[166632.391019] buffer dirty: block 35494 count 1
[166632.395251] buffer dirty: block 35496 count 1
[166632.399446] buffer dirty: block 35497 count 2
[166632.403644] buffer dirty: block 35498 count 3
[166632.407979] buffer dirty: block 35499 count 1
[166632.412221] buffer dirty: block 35501 count 2
[166632.416464] buffer dirty: block 35502 count 1
[166632.420726] buffer dirty: block 35503 count 1
[166632.424962] buffer dirty: block 35504 count 3
[166632.429169] buffer dirty: block 35505 count 1
[166632.433410] buffer dirty: block 35506 count 1
[166632.437580] buffer dirty: block 35507 count 3
[166632.441787] buffer dirty: block 35508 count 1
[166632.446056] buffer dirty: block 35509 count 2
[166632.450333] buffer dirty: block 35510 count 2
[166632.454579] buffer dirty: block 35512 count 1
[166632.458791] buffer dirty: block 35513 count 1
[166632.462964] buffer dirty: block 35514 count 2
[166632.467136] buffer dirty: block 35515 count 1
[166632.471309] buffer dirty: block 35517 count 1
[166632.475482] buffer dirty: block 35518 count 2
[166632.479651] buffer dirty: block 35519 count 2
[166632.483933] buffer dirty: block 35522 count 1
[166632.488066] buffer dirty: block 35523 count 1
[166632.492162] buffer dirty: block 35524 count 1
[166632.496258] buffer dirty: block 35525 count 4
[166632.500350] buffer dirty: block 35527 count 1
[166632.504476] buffer dirty: block 35528 count 2
[166632.508607] buffer dirty: block 35529 count 3
[166632.512736] buffer dirty: block 35533 count 3
[166632.516831] buffer dirty: block 35536 count 1
[166632.520973] buffer dirty: block 35537 count 3
[166632.525138] buffer dirty: block 35538 count 1
[166632.529267] buffer dirty: block 35539 count 3
[166632.533398] buffer dirty: block 35541 count 1
[166632.537526] buffer dirty: block 35542 count 2
[166632.541653] buffer dirty: block 35543 count 1
[166632.545820] buffer dirty: block 35544 count 1
[166632.549949] buffer dirty: block 35545 count 2
[166632.554048] buffer dirty: block 35547 count 3
[166632.558216] buffer dirty: block 35548 count 2
[166632.562388] buffer dirty: block 35549 count 1
[166632.566521] buffer dirty: block 35550 count 1
[166632.570624] buffer dirty: block 35552 count 1
[166632.574755] buffer dirty: block 35553 count 2
[166632.578887] buffer dirty: block 35554 count 1
[166632.583055] buffer dirty: block 35555 count 2
[166632.587226] buffer dirty: block 35556 count 1
[166632.591395] buffer dirty: block 35557 count 2
[166632.595574] buffer dirty: block 35558 count 1
[166632.599780] buffer dirty: block 35559 count 1
[166632.603989] buffer dirty: block 35560 count 3
[166632.608196] buffer dirty: block 35563 count 1
[166632.612446] buffer dirty: block 35564 count 3
[166632.616729] buffer dirty: block 35565 count 1
[166632.621013] buffer dirty: block 35567 count 1
[166632.625222] buffer dirty: block 35568 count 3
[166632.629432] buffer dirty: block 35569 count 1
[166632.633643] buffer dirty: block 35570 count 1
[166632.637849] buffer dirty: block 35571 count 1
[166632.642020] buffer dirty: block 35572 count 2
[166632.646190] buffer dirty: block 35573 count 2
[166632.650316] buffer dirty: block 35574 count 1
[166632.654448] buffer dirty: block 35575 count 2
[166632.658569] buffer dirty: block 35576 count 1
[166632.662693] buffer dirty: block 35577 count 1
[166632.666776] buffer dirty: block 35578 count 2
[166632.670902] buffer dirty: block 35579 count 2
[166632.674989] buffer dirty: block 35580 count 1
[166632.679078] buffer dirty: block 35583 count 2
[166632.683166] buffer dirty: block 35584 count 2
[166632.687216] buffer dirty: block 35585 count 1
[166632.691299] buffer dirty: block 35587 count 2
[166632.695420] buffer dirty: block 35588 count 1
[166632.699540] buffer dirty: block 35589 count 2
[166632.703657] buffer dirty: block 35590 count 1
[166632.707955] buffer dirty: block 35591 count 1
[166632.712075] buffer dirty: block 35592 count 1
[166632.716151] buffer dirty: block 35593 count 1
[166632.720187] buffer dirty: block 35594 count 3
[166632.724299] buffer dirty: block 35595 count 1
[166632.728375] buffer dirty: block 35597 count 2
[166632.732556] buffer dirty: block 35598 count 2
[166632.736610] buffer dirty: block 35599 count 2
[166632.740614] buffer dirty: block 35600 count 1
[166632.744688] buffer dirty: block 35603 count 4
[166632.748791] buffer dirty: block 35605 count 1
[166632.752897] buffer dirty: block 35606 count 1
[166632.757033] buffer dirty: block 35607 count 1
[166632.761136] buffer dirty: block 35608 count 2
[166632.765271] buffer dirty: block 35609 count 2
[166632.769409] buffer dirty: block 35610 count 1
[166632.773546] buffer dirty: block 35611 count 1
[166632.777652] buffer dirty: block 35613 count 2
[166632.781755] buffer dirty: block 35614 count 2
[166632.785898] buffer dirty: block 35616 count 2
[166632.790067] buffer dirty: block 35617 count 1
[166632.794205] buffer dirty: block 35618 count 3
[166632.798306] buffer dirty: block 35619 count 1
[166632.802439] buffer dirty: block 35620 count 1
[166632.806579] buffer dirty: block 35621 count 1
[166632.810682] buffer dirty: block 35622 count 2
[166632.814749] buffer dirty: block 35623 count 1
[166632.818817] buffer dirty: block 35624 count 1
[166632.822850] buffer dirty: block 35626 count 4
[166632.826910] buffer dirty: block 35628 count 2
[166632.830971] buffer dirty: block 35629 count 1
[166632.835112] buffer dirty: block 35630 count 2
[166632.839290] buffer dirty: block 35632 count 1
[166632.843435] buffer dirty: block 35633 count 1
[166632.847543] buffer dirty: block 35634 count 1
[166632.851611] buffer dirty: block 35635 count 1
[166632.855679] buffer dirty: block 35636 count 1
[166632.859782] buffer dirty: block 35637 count 1
[166632.863805] buffer dirty: block 35638 count 5
[166632.867796] buffer dirty: block 35639 count 1
[166632.871789] buffer dirty: block 35642 count 1
[166632.875784] buffer dirty: block 35643 count 2
[166632.879971] buffer dirty: block 35644 count 2
[166632.883960] buffer dirty: block 35645 count 1
[166632.888025] buffer dirty: block 35646 count 2
[166632.892087] buffer dirty: block 35648 count 3
[166632.896154] buffer dirty: block 35649 count 1
[166632.900291] buffer dirty: block 35650 count 2
[166632.904422] buffer dirty: block 35652 count 1
[166632.908574] buffer dirty: block 35653 count 2
[166632.912757] buffer dirty: block 35654 count 2
[166632.916904] buffer dirty: block 35656 count 3
[166632.921019] buffer dirty: block 35657 count 1
[166632.925166] buffer dirty: block 35658 count 1
[166632.929317] buffer dirty: block 35659 count 2
[166632.933461] buffer dirty: block 35660 count 1
[166632.937615] buffer dirty: block 35663 count 1
[166632.941768] buffer dirty: block 35664 count 2
[166632.945888] buffer dirty: block 35665 count 1
[166632.950007] buffer dirty: block 35666 count 1
[166632.954054] buffer dirty: block 35667 count 1
[166632.958098] buffer dirty: block 35668 count 1
[166632.962130] buffer dirty: block 35669 count 2
[166632.966199] buffer dirty: block 35670 count 3
[166632.970344] buffer dirty: block 35673 count 1
[166632.974530] buffer dirty: block 35674 count 1
[166632.978683] buffer dirty: block 35675 count 2
[166632.982876] buffer dirty: block 35676 count 1
[166632.987069] buffer dirty: block 35678 count 1
[166632.991219] buffer dirty: block 35679 count 4
[166632.995372] buffer dirty: block 35683 count 2
[166632.999496] buffer dirty: block 35684 count 1
[166633.003662] buffer dirty: block 35685 count 1
[166633.007809] buffer dirty: block 35686 count 1
[166633.011994] buffer dirty: block 35687 count 1
[166633.016019] buffer dirty: block 35688 count 2
[166633.020042] buffer dirty: block 35689 count 2
[166633.024052] buffer dirty: block 35690 count 1
[166633.028096] buffer dirty: block 35691 count 1
[166633.032132] buffer dirty: block 35693 count 1
[166633.036170] buffer dirty: block 35694 count 1
[166633.040205] buffer dirty: block 35696 count 2
[166633.044235] buffer dirty: block 35697 count 1
[166633.048338] buffer dirty: block 35698 count 1
[166633.052433] buffer dirty: block 35699 count 3
[166633.056548] buffer dirty: block 35701 count 1
[166633.060669] buffer dirty: block 35702 count 1
[166633.064800] buffer dirty: block 35703 count 2
[166633.068934] buffer dirty: block 35704 count 1
[166633.073105] buffer dirty: block 35705 count 1
[166633.077244] buffer dirty: block 35706 count 1
[166633.081350] buffer dirty: block 35707 count 1
[166633.085417] buffer dirty: block 35708 count 1
[166633.089409] buffer dirty: block 35709 count 2
[166633.093433] buffer dirty: block 35710 count 1
[166633.097534] buffer dirty: block 35711 count 1
[166633.101628] buffer dirty: block 35712 count 1
[166633.105686] buffer dirty: block 35713 count 2
[166633.109818] buffer dirty: block 35715 count 2
[166633.113908] buffer dirty: block 35716 count 2
[166633.117958] buffer dirty: block 35717 count 1
[166633.122037] buffer dirty: block 35718 count 2
[166633.126112] buffer dirty: block 35719 count 1
[166633.130229] buffer dirty: block 35720 count 1
[166633.134346] buffer dirty: block 35721 count 1
[166633.138425] buffer dirty: block 35722 count 2
[166633.142506] buffer dirty: block 35723 count 3
[166633.146558] buffer dirty: block 35726 count 2
[166633.150646] buffer dirty: block 35728 count 3
[166633.154777] buffer dirty: block 35729 count 1
[166633.158914] buffer dirty: block 35730 count 1
[166633.163011] buffer dirty: block 35731 count 1
[166633.167076] buffer dirty: block 35732 count 2
[166633.171179] buffer dirty: block 35733 count 2
[166633.175242] buffer dirty: block 35734 count 2
[166633.179260] buffer dirty: block 35735 count 1
[166633.183519] buffer dirty: block 35736 count 1
[166633.187544] buffer dirty: block 35738 count 4
[166633.191633] buffer dirty: block 35739 count 2
[166633.195897] buffer dirty: block 35741 count 1
[166633.200026] buffer dirty: block 35742 count 1
[166633.204191] buffer dirty: block 35743 count 2
[166633.208362] buffer dirty: block 35746 count 2
[166633.212499] buffer dirty: block 35748 count 3
[166633.216599] buffer dirty: block 35749 count 2
[166633.220699] buffer dirty: block 35750 count 1
[166633.224833] buffer dirty: block 35752 count 2
[166633.228931] buffer dirty: block 35753 count 3
[166633.233111] buffer dirty: block 35754 count 1
[166633.237313] buffer dirty: block 35756 count 1
[166633.241488] buffer dirty: block 35758 count 4
[166633.245667] buffer dirty: block 35759 count 2
[166633.249841] buffer dirty: block 35760 count 1
[166633.254052] buffer dirty: block 35762 count 2
[166633.258270] buffer dirty: block 35763 count 3
[166633.262523] buffer dirty: block 35764 count 1
[166633.266776] buffer dirty: block 35765 count 1
[166633.270959] buffer dirty: block 35766 count 2
[166633.275140] buffer dirty: block 35768 count 2
[166633.279283] buffer dirty: block 35769 count 2
[166633.283421] buffer dirty: block 35771 count 2
[166633.287529] buffer dirty: block 35772 count 1
[166633.291639] buffer dirty: block 35773 count 1
[166633.295712] buffer dirty: block 35775 count 1
[166633.299970] buffer dirty: block 35776 count 1
[166633.303976] buffer dirty: block 35777 count 2
[166633.308047] buffer dirty: block 35778 count 1
[166633.312089] buffer dirty: block 35779 count 1
[166633.316122] buffer dirty: block 35780 count 1
[166633.320119] buffer dirty: block 35781 count 2
[166633.324185] buffer dirty: block 35782 count 2
[166633.328244] buffer dirty: block 35784 count 1
[166633.332323] buffer dirty: block 35785 count 1
[166633.336382] buffer dirty: block 35786 count 1
[166633.340441] buffer dirty: block 35787 count 2
[166633.344503] buffer dirty: block 35788 count 1
[166633.348564] buffer dirty: block 35789 count 2
[166633.352625] buffer dirty: block 35792 count 5
[166633.356694] buffer dirty: block 35793 count 1
[166633.360796] buffer dirty: block 35795 count 1
[166633.364898] buffer dirty: block 35796 count 2
[166633.369004] buffer dirty: block 35797 count 1
[166633.373136] buffer dirty: block 35798 count 4
[166633.377268] buffer dirty: block 35799 count 2
[166633.381398] buffer dirty: block 35800 count 1
[166633.385531] buffer dirty: block 35801 count 1
[166633.389664] buffer dirty: block 35802 count 1
[166633.393754] buffer dirty: block 35803 count 1
[166633.397846] buffer dirty: block 35804 count 1
[166633.401937] buffer dirty: block 35806 count 1
[166633.406030] buffer dirty: block 35807 count 1
[166633.410083] buffer dirty: block 35808 count 2
[166633.414210] buffer dirty: block 35809 count 2
[166633.418341] buffer dirty: block 35811 count 1
[166633.422479] buffer dirty: block 35812 count 1
[166633.426576] buffer dirty: block 35813 count 1
[166633.430668] buffer dirty: block 35815 count 2
[166633.434769] buffer dirty: block 35816 count 4
[166633.438936] buffer dirty: block 35818 count 1
[166633.443067] buffer dirty: block 35819 count 2
[166633.447205] buffer dirty: block 35820 count 1
[166633.451348] buffer dirty: block 35821 count 1
[166633.455492] buffer dirty: block 35822 count 1
[166633.459603] buffer dirty: block 35824 count 2
[166633.463711] buffer dirty: block 35825 count 1
[166633.467821] buffer dirty: block 35826 count 2
[166633.471998] buffer dirty: block 35827 count 2
[166633.476031] buffer dirty: block 35828 count 2
[166633.479995] buffer dirty: block 35829 count 1
[166633.483957] buffer dirty: block 35830 count 2
[166633.484035] buffer dirty: block 35832 count 2
[166633.488006] buffer dirty: block 35834 count 2
[166633.491937] buffer dirty: block 35835 count 2
[166633.495863] buffer dirty: block 35836 count 2
[166633.499748] buffer dirty: block 35838 count 2
[166633.503592] buffer dirty: block 35839 count 1
[166633.507479] buffer dirty: block 35840 count 2
[166633.511407] buffer dirty: block 35842 count 2
[166633.515374] buffer dirty: block 35843 count 1
[166633.519376] buffer dirty: block 35844 count 1
[166633.523369] buffer dirty: block 35845 count 2
[166633.527366] buffer dirty: block 35846 count 2
[166633.531393] buffer dirty: block 35848 count 2
[166633.535411] buffer dirty: block 35849 count 2
[166633.539425] buffer dirty: block 35851 count 1
[166633.543484] buffer dirty: block 35852 count 3
[166633.547574] buffer dirty: block 35853 count 1
[166633.551630] buffer dirty: block 35854 count 1
[166633.555645] buffer dirty: block 35856 count 2
[166633.559692] buffer dirty: block 35857 count 1
[166633.563768] buffer dirty: block 35858 count 1
[166633.567843] buffer dirty: block 35859 count 3
[166633.571960] buffer dirty: block 35861 count 1
[166633.576081] buffer dirty: block 35862 count 4
[166633.583931] buffer dirty: block 35866 count 1
[166633.588061] buffer dirty: block 35867 count 1
[166633.592174] buffer dirty: block 35868 count 2
[166633.596299] buffer dirty: block 35869 count 2
[166633.600418] buffer dirty: block 35872 count 2
[166633.604467] buffer dirty: block 35874 count 1
[166633.608587] buffer dirty: block 35876 count 1
[166633.612672] buffer dirty: block 35877 count 3
[166633.616798] buffer dirty: block 35878 count 2
[166633.620961] buffer dirty: block 35879 count 1
[166633.625124] buffer dirty: block 35880 count 2
[166633.629328] buffer dirty: block 35881 count 2
[166633.633523] buffer dirty: block 35882 count 2
[166633.637897] buffer dirty: block 1081370 count 1
[166633.642089] buffer dirty: block 2588673 count 1
[166633.646391] buffer dirty: block 2588727 count 2
[166633.650767] Total number of dirty buffers: 24754

for /home

and

[166982.440144] buffer dirty: block 31549 count 1
[166982.443561] buffer dirty: block 31573 count 1
[166982.446978] buffer dirty: block 31586 count 1
[166982.450372] buffer dirty: block 31590 count 1
[166982.453800] buffer dirty: block 31601 count 1
[166982.457235] buffer dirty: block 31609 count 1
[166982.460667] buffer dirty: block 31611 count 1
[166982.464047] buffer dirty: block 31614 count 1
[166982.467477] buffer dirty: block 31615 count 1
[166982.470903] buffer dirty: block 31621 count 1
[166982.474333] buffer dirty: block 31634 count 1
[166982.477760] buffer dirty: block 31644 count 1
[166982.481154] buffer dirty: block 31645 count 1
[166982.484538] buffer dirty: block 31648 count 2
[166982.487915] buffer dirty: block 31651 count 1
[166982.491929] buffer dirty: block 31659 count 1
[166982.495424] buffer dirty: block 31660 count 1
[166982.498919] buffer dirty: block 31662 count 1
[166982.502421] buffer dirty: block 31666 count 1
[166982.505912] buffer dirty: block 31667 count 1
[166982.509365] buffer dirty: block 31668 count 1
[166982.512218] buffer dirty: block 31676 count 1
[166982.515629] buffer dirty: block 31697 count 1
[166982.519043] buffer dirty: block 31700 count 1
[166982.522461] buffer dirty: block 31701 count 1
[166982.525872] buffer dirty: block 31704 count 1
[166982.529258] buffer dirty: block 31708 count 1
[166982.532642] buffer dirty: block 31713 count 1
[166982.536013] buffer dirty: block 31738 count 2
[166982.539441] buffer dirty: block 31751 count 2
[166982.542868] buffer dirty: block 31754 count 1
[166982.546336] buffer dirty: block 31764 count 1
[166982.549799] buffer dirty: block 31787 count 1
[166982.553225] buffer dirty: block 31788 count 1
[166982.556649] buffer dirty: block 31795 count 1
[166982.560026] buffer dirty: block 31796 count 1
[166982.563448] buffer dirty: block 31809 count 1
[166982.566881] buffer dirty: block 31810 count 1
[166982.570324] buffer dirty: block 31822 count 1
[166982.573766] buffer dirty: block 31833 count 1
[166982.577208] buffer dirty: block 31834 count 1
[166982.580648] buffer dirty: block 31837 count 1
[166982.584060] buffer dirty: block 31840 count 1
[166982.587460] buffer dirty: block 31843 count 1
[166982.590891] buffer dirty: block 31846 count 1
[166982.594249] buffer dirty: block 31849 count 1
[166982.597571] buffer dirty: block 31862 count 1
[166982.600859] buffer dirty: block 31878 count 1
[166982.604131] buffer dirty: block 31886 count 1
[166982.607427] buffer dirty: block 31889 count 1
[166982.610722] buffer dirty: block 31896 count 1
[166982.614052] buffer dirty: block 31899 count 1
[166982.617373] buffer dirty: block 31903 count 1
[166982.620660] buffer dirty: block 31906 count 1
[166982.623963] buffer dirty: block 31907 count 1
[166982.627985] buffer dirty: block 31912 count 1
[166982.631376] buffer dirty: block 31920 count 1
[166982.634768] buffer dirty: block 31936 count 1
[166982.638119] buffer dirty: block 31937 count 1
[166982.641467] buffer dirty: block 31943 count 1
[166982.644111] buffer dirty: block 31947 count 1
[166982.647427] buffer dirty: block 31950 count 1
[166982.650742] buffer dirty: block 31953 count 1
[166982.654054] buffer dirty: block 31956 count 2
[166982.657401] buffer dirty: block 31967 count 1
[166982.660791] buffer dirty: block 31980 count 1
[166982.664088] buffer dirty: block 31981 count 1
[166982.667466] buffer dirty: block 31990 count 1
[166982.670845] buffer dirty: block 31998 count 1
[166982.674225] buffer dirty: block 31999 count 1
[166982.677602] buffer dirty: block 32002 count 1
[166982.680986] buffer dirty: block 32006 count 1
[166982.684363] buffer dirty: block 32030 count 1
[166982.687736] buffer dirty: block 32031 count 1
[166982.691751] buffer dirty: block 32032 count 1
[166982.695184] buffer dirty: block 32035 count 1
[166982.698611] buffer dirty: block 32049 count 1
[166982.702032] buffer dirty: block 32059 count 1
[166982.705452] buffer dirty: block 32065 count 1
[166982.708201] buffer dirty: block 32079 count 1
[166982.711583] buffer dirty: block 32082 count 1
[166982.714999] buffer dirty: block 32083 count 1
[166982.718395] buffer dirty: block 32096 count 1
[166982.721814] buffer dirty: block 32109 count 1
[166982.725212] buffer dirty: block 32123 count 1
[166982.728601] buffer dirty: block 32126 count 1
[166982.731973] buffer dirty: block 32132 count 1
[166982.736004] buffer dirty: block 32138 count 1
[166982.739399] buffer dirty: block 32146 count 1
[166982.742793] buffer dirty: block 32155 count 1
[166982.746225] buffer dirty: block 32156 count 1
[166982.749652] buffer dirty: block 32168 count 1
[166982.752417] buffer dirty: block 32169 count 1
[166982.755789] buffer dirty: block 32170 count 1
[166982.759844] buffer dirty: block 32171 count 1
[166982.763194] buffer dirty: block 32175 count 1
[166982.766542] buffer dirty: block 32181 count 1
[166982.769890] buffer dirty: block 32182 count 1
[166982.772614] buffer dirty: block 32184 count 1
[166982.775947] buffer dirty: block 32188 count 1
[166982.779961] buffer dirty: block 32189 count 1
[166982.783334] buffer dirty: block 32190 count 1
[166982.786711] buffer dirty: block 32191 count 1
[166982.790093] buffer dirty: block 32193 count 1
[166982.793437] buffer dirty: block 32194 count 1
[166982.796097] buffer dirty: block 32197 count 1
[166982.799432] buffer dirty: block 32198 count 1
[166982.802773] buffer dirty: block 32200 count 1
[166982.806115] buffer dirty: block 32201 count 1
[166982.809455] buffer dirty: block 32203 count 1
[166982.812788] buffer dirty: block 32208 count 1
[166982.816101] buffer dirty: block 32213 count 1
[166982.819398] buffer dirty: block 32220 count 1
[166982.822729] buffer dirty: block 32225 count 1
[166982.826023] buffer dirty: block 32230 count 2
[166982.829358] buffer dirty: block 32231 count 1
[166982.832620] buffer dirty: block 32234 count 1
[166982.835977] buffer dirty: block 32235 count 1
[166982.839992] buffer dirty: block 32239 count 1
[166982.843356] buffer dirty: block 32240 count 1
[166982.846727] buffer dirty: block 32243 count 1
[166982.850094] buffer dirty: block 32254 count 1
[166982.853461] buffer dirty: block 32273 count 1
[166982.856173] buffer dirty: block 32274 count 1
[166982.859537] buffer dirty: block 32280 count 1
[166982.862909] buffer dirty: block 32314 count 1
[166982.866287] buffer dirty: block 32322 count 1
[166982.869667] buffer dirty: block 32323 count 1
[166982.873043] buffer dirty: block 32326 count 1
[166982.876407] buffer dirty: block 32329 count 1
[166982.879733] buffer dirty: block 32332 count 1
[166982.883789] buffer dirty: block 32338 count 1
[166982.887166] buffer dirty: block 32345 count 1
[166982.890544] buffer dirty: block 32346 count 1
[166982.893925] buffer dirty: block 32356 count 1
[166982.896590] buffer dirty: block 32357 count 1
[166982.899956] buffer dirty: block 32361 count 1
[166982.903980] buffer dirty: block 32362 count 1
[166982.907394] buffer dirty: block 32365 count 1
[166982.910813] buffer dirty: block 32368 count 1
[166982.914233] buffer dirty: block 32371 count 1
[166982.917648] buffer dirty: block 32374 count 1
[166982.920385] buffer dirty: block 32381 count 1
[166982.923781] buffer dirty: block 32396 count 1
[166982.927797] buffer dirty: block 32405 count 1
[166982.931177] buffer dirty: block 32413 count 1
[166982.934555] buffer dirty: block 32421 count 2
[166982.937974] buffer dirty: block 32422 count 1
[166982.941399] buffer dirty: block 32425 count 1
[166982.944154] buffer dirty: block 32428 count 1
[166982.947571] buffer dirty: block 32432 count 1
[166982.950988] buffer dirty: block 32435 count 2
[166982.954443] buffer dirty: block 32436 count 1
[166982.957940] buffer dirty: block 32438 count 1
[166982.961467] buffer dirty: block 32446 count 2
[166982.965030] buffer dirty: block 32475 count 1
[166982.968630] buffer dirty: block 32478 count 2
[166982.972036] buffer dirty: block 32481 count 2
[166982.975707] buffer dirty: block 32482 count 1
[166982.979419] buffer dirty: block 32490 count 1
[166982.983130] buffer dirty: block 32491 count 1
[166982.986808] buffer dirty: block 32492 count 1
[166982.990482] buffer dirty: block 32514 count 1
[166982.994162] buffer dirty: block 32515 count 1
[166982.997839] buffer dirty: block 32522 count 1
[166983.001536] buffer dirty: block 32523 count 1
[166983.005292] buffer dirty: block 32526 count 1
[166983.009010] buffer dirty: block 32555 count 1
[166983.012729] buffer dirty: block 32556 count 1
[166983.016458] buffer dirty: block 32560 count 1
[166983.020089] buffer dirty: block 32563 count 1
[166983.023796] buffer dirty: block 32566 count 1
[166983.027825] buffer dirty: block 32569 count 1
[166983.031508] buffer dirty: block 32584 count 1
[166983.035157] buffer dirty: block 32593 count 1
[166983.038806] buffer dirty: block 32660 count 1
[166983.042422] buffer dirty: block 32666 count 1
[166983.046000] buffer dirty: block 32680 count 1
[166983.049579] buffer dirty: block 32703 count 1
[166983.053165] buffer dirty: block 32706 count 1
[166983.056750] buffer dirty: block 32709 count 1
[166983.060163] buffer dirty: block 32716 count 1
[166983.063670] buffer dirty: block 32719 count 1
[166983.067219] buffer dirty: block 32722 count 1
[166983.070689] buffer dirty: block 32723 count 1
[166983.074134] buffer dirty: block 32726 count 1
[166983.077526] buffer dirty: block 32729 count 1
[166983.080888] buffer dirty: block 32744 count 1
[166983.084157] buffer dirty: block 32767 count 1
[166983.087458] buffer dirty: block 33329 count 1
[166983.090791] buffer dirty: block 33337 count 2
[166983.094195] buffer dirty: block 33708 count 1
[166983.097642] buffer dirty: block 33711 count 1
[166983.101091] buffer dirty: block 33726 count 1
[166983.104412] buffer dirty: block 33735 count 1
[166983.107774] buffer dirty: block 33755 count 1
[166983.111869] buffer dirty: block 33789 count 1
[166983.115252] buffer dirty: block 33797 count 1
[166983.118638] buffer dirty: block 33798 count 1
[166983.122017] buffer dirty: block 33811 count 1
[166983.125405] buffer dirty: block 33835 count 1
[166983.128131] buffer dirty: block 33836 count 1
[166983.131518] buffer dirty: block 33839 count 1
[166983.134911] buffer dirty: block 33843 count 1
[166983.138330] buffer dirty: block 33847 count 1
[166983.141742] buffer dirty: block 33848 count 1
[166983.145156] buffer dirty: block 33851 count 1
[166983.148544] buffer dirty: block 33865 count 1
[166983.151935] buffer dirty: block 33888 count 1
[166983.155959] buffer dirty: block 33891 count 1
[166983.159407] buffer dirty: block 33899 count 1
[166983.162849] buffer dirty: block 33902 count 1
[166983.166302] buffer dirty: block 33903 count 1
[166983.169750] buffer dirty: block 33933 count 1
[166983.172554] buffer dirty: block 33970 count 1
[166983.175986] buffer dirty: block 34007 count 1
[166983.180001] buffer dirty: block 34044 count 1
[166983.183500] buffer dirty: block 34081 count 1
[166983.187029] buffer dirty: block 34118 count 1
[166983.190525] buffer dirty: block 34127 count 1
[166983.194015] buffer dirty: block 34140 count 1
[166983.197426] buffer dirty: block 34164 count 1
[166983.200403] buffer dirty: block 34167 count 1
[166983.203799] buffer dirty: block 34168 count 1
[166983.207813] buffer dirty: block 34171 count 1
[166983.211258] buffer dirty: block 34174 count 1
[166983.214695] buffer dirty: block 34177 count 1
[166983.218129] buffer dirty: block 34180 count 1
[166983.221565] buffer dirty: block 34214 count 1
[166983.224433] buffer dirty: block 34222 count 1
[166983.227847] buffer dirty: block 34223 count 1
[166983.231864] buffer dirty: block 34226 count 1
[166983.235337] buffer dirty: block 34239 count 1
[166983.238772] buffer dirty: block 34263 count 1
[166983.242213] buffer dirty: block 34264 count 1
[166983.245656] buffer dirty: block 34267 count 1
[166983.248520] buffer dirty: block 34283 count 1
[166983.251940] buffer dirty: block 34291 count 1
[166983.255959] buffer dirty: block 34358 count 1
[166983.259397] buffer dirty: block 34364 count 1
[166983.262837] buffer dirty: block 34378 count 1
[166983.266273] buffer dirty: block 34401 count 1
[166983.269711] buffer dirty: block 34407 count 1
[166983.272572] buffer dirty: block 34410 count 1
[166983.275959] buffer dirty: block 34413 count 1
[166983.280004] buffer dirty: block 34421 count 1
[166983.283404] buffer dirty: block 34424 count 1
[166983.286759] buffer dirty: block 34425 count 1
[166983.290109] buffer dirty: block 34428 count 1
[166983.293420] buffer dirty: block 34431 count 1
[166983.296198] buffer dirty: block 34432 count 1
[166983.299505] buffer dirty: block 34461 count 1
[166983.302814] buffer dirty: block 34462 count 1
[166983.306093] buffer dirty: block 34468 count 1
[166983.309370] buffer dirty: block 34484 count 1
[166983.312644] buffer dirty: block 34492 count 1
[166983.315909] buffer dirty: block 34513 count 1
[166983.319930] buffer dirty: block 34547 count 1
[166983.323247] buffer dirty: block 34555 count 1
[166983.326563] buffer dirty: block 34556 count 1
[166983.329879] buffer dirty: block 34560 count 1
[166983.332417] buffer dirty: block 34564 count 1
[166983.335697] buffer dirty: block 34567 count 1
[166983.338974] buffer dirty: block 34570 count 1
[166983.342253] buffer dirty: block 34583 count 1
[166983.345535] buffer dirty: block 34607 count 1
[166983.348823] buffer dirty: block 34608 count 1
[166983.352086] buffer dirty: block 34611 count 1
[166983.355332] buffer dirty: block 34614 count 1
[166983.358613] buffer dirty: block 34627 count 1
[166983.361863] buffer dirty: block 34651 count 1
[166983.365115] buffer dirty: block 34654 count 1
[166983.368339] buffer dirty: block 34662 count 1
[166983.371578] buffer dirty: block 34665 count 1
[166983.374825] buffer dirty: block 34668 count 1
[166983.378073] buffer dirty: block 34671 count 1
[166983.381390] buffer dirty: block 131150 count 1
[166983.384564] buffer dirty: block 131151 count 2
[166983.387911] buffer dirty: block 131152 count 1
[166983.391926] buffer dirty: block 131153 count 2
[166983.395369] buffer dirty: block 131154 count 1
[166983.398847] buffer dirty: block 131155 count 2
[166983.402359] buffer dirty: block 131156 count 1
[166983.405914] buffer dirty: block 131157 count 1
[166983.409471] buffer dirty: block 131159 count 1
[166983.412215] buffer dirty: block 131189 count 2
[166983.415897] buffer dirty: block 491704 count 1
[166983.419541] buffer dirty: block 491929 count 1
[166983.423176] buffer dirty: block 491932 count 1
[166983.426839] buffer dirty: block 491933 count 1
[166983.430482] buffer dirty: block 524297 count 1
[166983.434135] buffer dirty: block 524301 count 1
[166983.437797] buffer dirty: block 524303 count 1
[166983.441455] buffer dirty: block 524304 count 2
[166983.445149] buffer dirty: block 524305 count 1
[166983.448881] buffer dirty: block 524310 count 1
[166983.452613] buffer dirty: block 524311 count 1
[166983.456164] buffer dirty: block 524315 count 1
[166983.459876] buffer dirty: block 524326 count 1
[166983.463895] buffer dirty: block 524331 count 1
[166983.467661] buffer dirty: block 524391 count 1
[166983.471583] buffer dirty: block 1114244 count 1
[166983.475404] buffer dirty: block 1114246 count 1
[166983.479290] buffer dirty: block 1212425 count 1
[166983.483192] buffer dirty: block 1245295 count 1
[166983.487102] buffer dirty: block 1245383 count 1
[166983.491036] buffer dirty: block 1278016 count 1
[166983.495167] Total number of dirty buffers: 5421

for /

--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabinfo

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
nfsd4_delegations      0      0    212   18    1 : tunables  120   60    0 : slabdata      0      0      0
nfsd4_stateids         0      0     72   53    1 : tunables  120   60    0 : slabdata      0      0      0
nfsd4_files            0      0     40   92    1 : tunables  120   60    0 : slabdata      0      0      0
nfsd4_stateowners      0      0    344   11    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_direct_cache       0      0     68   56    1 : tunables  120   60    0 : slabdata      0      0      0
nfs_write_data        36     36    416    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_read_data         32     36    416    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_inode_cache        0      0    592    6    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_page               0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    0 : slabdata      4      4      0
rpc_tasks              8     24    160   24    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_inode_cache        6      9    416    9    1 : tunables   54   27    0 : slabdata      1      1      0
fib6_nodes             7    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
ip6_dst_cache         10     30    256   15    1 : tunables  120   60    0 : slabdata      2      2      0
ndisc_cache            1     24    160   24    1 : tunables  120   60    0 : slabdata      1      1      0
RAWv6                  4      6    608    6    1 : tunables   54   27    0 : slabdata      1      1      0
UDPLITEv6              0      0    608    6    1 : tunables   54   27    0 : slabdata      0      0      0
UDPv6                  8     12    608    6    1 : tunables   54   27    0 : slabdata      2      2      0
tw_sock_TCPv6          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
request_sock_TCPv6      0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
TCPv6                 13     18   1184    6    2 : tunables   24   12    0 : slabdata      3      3      0
fuse_request           0      0    372   10    1 : tunables   54   27    0 : slabdata      0      0      0
fuse_inode             0      0    384   10    1 : tunables   54   27    0 : slabdata      0      0      0
uhci_urb_priv          0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
bridge_fdb_cache       5     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
flow_cache             0      0     80   48    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_io_context         0      0     88   44    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_queue              0      0     84   46    1 : tunables  120   60    0 : slabdata      0      0      0
mqueue_inode_cache      1      8    480    8    1 : tunables   54   27    0 : slabdata      1      1      0
xfs_ili                0      0    140   28    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_inode              0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_efi_item           0      0    260   15    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_efd_item           0      0    260   15    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_buf_item           0      0    148   26    1 : tunables  120   60    0 : slabdata      0      0      0
fstrm_item             0      0     12  254    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_mru_cache_elem      0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_acl                0      0    304   13    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_trans              0      0    612    6    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_ifork              0      0     56   67    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_dabuf              0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_da_state           0      0    336   11    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_btree_cur          0      0    132   29    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_bmap_free_item      0      0     12  254    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_log_ticket         0      0    172   23    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_buf                0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_ioend             32     67     56   67    1 : tunables  120   60    0 : slabdata      1      1      0
xfs_vnode              0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
isofs_inode_cache      0      0    332   12    1 : tunables   54   27    0 : slabdata      0      0      0
ext2_inode_cache       1      9    440    9    1 : tunables   54   27    0 : slabdata      1      1      0
ext2_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
jbd2_journal_handle      8    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
jbd2_journal_head     72     72     52   72    1 : tunables  120   60    0 : slabdata      1      1      0
jbd2_revoke_table      4    254     12  254    1 : tunables  120   60    0 : slabdata      1      1      0
jbd2_revoke_record      0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
journal_handle         0      0     20  169    1 : tunables  120   60    0 : slabdata      0      0      0
journal_head           0      0     52   72    1 : tunables  120   60    0 : slabdata      0      0      0
revoke_table           0      0     12  254    1 : tunables  120   60    0 : slabdata      0      0      0
revoke_record          0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
ext4_inode_cache     637   1008    488    8    1 : tunables   54   27    0 : slabdata    126    126      0
ext4_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
ext4_alloc_context     16     36    108   36    1 : tunables  120   60    0 : slabdata      1      1      0
ext4_prealloc_space     10     63     60   63    1 : tunables  120   60    0 : slabdata      1      1      0
ext3_inode_cache       0      0    448    9    1 : tunables   54   27    0 : slabdata      0      0      0
ext3_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
dnotify_cache          2    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
dquot                  0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_watch_cache      5     92     40   92    1 : tunables  120   60    0 : slabdata      1      1      0
kioctx                 0      0    160   24    1 : tunables  120   60    0 : slabdata      0      0      0
kiocb                  0      0    160   24    1 : tunables  120   60    0 : slabdata      0      0      0
fasync_cache           0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
shmem_inode_cache    694    702    404    9    1 : tunables   54   27    0 : slabdata     78     78      0
nsproxy                0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
posix_timers_cache      0      0    100   39    1 : tunables  120   60    0 : slabdata      0      0      0
uid_cache              9     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
UNIX                  42     50    384   10    1 : tunables   54   27    0 : slabdata      5      5      0
ip_mrt_cache           0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
UDP-Lite               0      0    480    8    1 : tunables   54   27    0 : slabdata      0      0      0
tcp_bind_bucket       31    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
inet_peer_cache        2     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
secpath_cache          0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
xfrm_dst_cache         0      0    288   13    1 : tunables   54   27    0 : slabdata      0      0      0
ip_fib_alias           0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
ip_fib_hash            9    101     36  101    1 : tunables  120   60    0 : slabdata      1      1      0
ip_dst_cache          35     75    256   15    1 : tunables  120   60    0 : slabdata      5      5      0
arp_cache              4     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
RAW                    3      8    480    8    1 : tunables   54   27    0 : slabdata      1      1      0
UDP                   35     40    480    8    1 : tunables   54   27    0 : slabdata      5      5      0
tw_sock_TCP            0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
request_sock_TCP       0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
TCP                   31     42   1088    7    2 : tunables   24   12    0 : slabdata      6      6      0
eventpoll_pwq          8    101     36  101    1 : tunables  120   60    0 : slabdata      1      1      0
eventpoll_epi          8     40     96   40    1 : tunables  120   60    0 : slabdata      1      1      0
blkdev_queue          20     20    980    4    1 : tunables   54   27    0 : slabdata      5      5      0
blkdev_requests       27     63    188   21    1 : tunables  120   60    0 : slabdata      3      3      0
blkdev_ioc            60     84     44   84    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-256             2      2   3072    2    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-128             2      5   1536    5    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-64              5      5    768    5    1 : tunables   54   27    0 : slabdata      1      1      0
biovec-16              6     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-4               6     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-1              17    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
bio                   47    177     64   59    1 : tunables  120   60    0 : slabdata      3      3      0
sock_inode_cache     146    176    352   11    1 : tunables   54   27    0 : slabdata     16     16      0
skbuff_fclone_cache     44     44    352   11    1 : tunables   54   27    0 : slabdata      4      4      0
skbuff_head_cache     96    620    192   20    1 : tunables  120   60    0 : slabdata     31     31      0
file_lock_cache       23     40     96   40    1 : tunables  120   60    0 : slabdata      1      1      0
Acpi-Operand         576    644     40   92    1 : tunables  120   60    0 : slabdata      7      7      0
Acpi-ParseExt          0      0     48   78    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-Parse             0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-Namespace       320    338     20  169    1 : tunables  120   60    0 : slabdata      2      2      0
proc_inode_cache     118    144    320   12    1 : tunables   54   27    0 : slabdata     12     12      0
sigqueue               4     27    144   27    1 : tunables  120   60    0 : slabdata      1      1      0
radix_tree_node     1872   2405    288   13    1 : tunables   54   27    0 : slabdata    185    185      0
bdev_cache             8      9    416    9    1 : tunables   54   27    0 : slabdata      1      1      0
sysfs_dir_cache     4101   4116     44   84    1 : tunables  120   60    0 : slabdata     49     49      0
mnt_cache             26     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
inode_cache           98    182    304   13    1 : tunables   54   27    0 : slabdata     14     14      0
dentry              1697   3534    124   31    1 : tunables  120   60    0 : slabdata    114    114      0
filp                1075   1260    128   30    1 : tunables  120   60    0 : slabdata     42     42      0
names_cache            1      1   4096    1    1 : tunables   24   12    0 : slabdata      1      1      0
buffer_head        30386  34488     52   72    1 : tunables  120   60    0 : slabdata    479    479      0
mm_struct             64     70    384   10    1 : tunables   54   27    0 : slabdata      7      7      0
vm_area_struct      2173   2346     84   46    1 : tunables  120   60    0 : slabdata     51     51      0
fs_cache              69    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
files_cache           66     80    192   20    1 : tunables  120   60    0 : slabdata      4      4      0
signal_cache          93     99    448    9    1 : tunables   54   27    0 : slabdata     11     11      0
sighand_cache         93     93   1312    3    1 : tunables   24   12    0 : slabdata     31     31      0
task_xstate           48     64    512    8    1 : tunables   54   27    0 : slabdata      8      8      0
task_struct           96    108    864    9    2 : tunables   54   27    0 : slabdata     12     12      0
anon_vma            1114   1356      8  339    1 : tunables  120   60    0 : slabdata      4      4      0
pid                  106    118     64   59    1 : tunables  120   60    0 : slabdata      2      2      0
idr_layer_cache      158    174    136   29    1 : tunables  120   60    0 : slabdata      6      6      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            2      2 131072    1   32 : tunables    8    4    0 : slabdata      2      2      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             1      1  32768    1    8 : tunables    8    4    0 : slabdata      1      1      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192             19     19   8192    1    2 : tunables    8    4    0 : slabdata     19     19      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
size-4096             28     28   4096    1    1 : tunables   24   12    0 : slabdata     28     28      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
size-2048            112    124   2048    2    1 : tunables   24   12    0 : slabdata     62     62      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
size-1024            153    156   1024    4    1 : tunables   54   27    0 : slabdata     39     39      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
size-512             492    528    512    8    1 : tunables   54   27    0 : slabdata     66     66      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
size-256             266    360    256   15    1 : tunables  120   60    0 : slabdata     24     24      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
size-192             148    160    192   20    1 : tunables  120   60    0 : slabdata      8      8      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
size-128             938   1020    128   30    1 : tunables  120   60    0 : slabdata     34     34      0
size-96(DMA)           0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
size-96              574   1400     96   40    1 : tunables  120   60    0 : slabdata     35     35      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
size-64             2386   2950     64   59    1 : tunables  120   60    0 : slabdata     50     50      0
size-32             3708   3729     32  113    1 : tunables  120   60    0 : slabdata     33     33      0
kmem_cache           174    200     96   40    1 : tunables  120   60    0 : slabdata      5      5      0

--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=meminfo

MemTotal:       189144 kB
MemFree:          7424 kB
Buffers:        127968 kB
Cached:          30444 kB
SwapCached:       5572 kB
Active:          63172 kB
Inactive:       101800 kB
SwapTotal:      506036 kB
SwapFree:       477668 kB
Dirty:              92 kB
Writeback:           0 kB
AnonPages:        5936 kB
Mapped:           3860 kB
Slab:             7588 kB
SReclaimable:     3816 kB
SUnreclaim:       3772 kB
PageTables:       1164 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
WritebackTmp:        0 kB
CommitLimit:    600608 kB
Committed_AS:    83880 kB
VmallocTotal:   843468 kB
VmallocUsed:     68640 kB
VmallocChunk:   774360 kB

--rJwd6BRFiFCcLxzm--
